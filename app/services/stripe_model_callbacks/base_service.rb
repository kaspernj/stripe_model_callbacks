class StripeModelCallbacks::BaseService < ServicePattern::Service
  def self.reported_execute!(*args, **opts, &blk)
    with_exception_notifications do
      response = execute(*args, **opts, &blk)
      raise response.errors.join(". ") unless response.success?

      response
    end
  end

  def self.with_exception_notifications
    yield
  rescue => e # rubocop:disable Style/RescueStandardError
    Rails.logger.error "ERROR: #{e.message}"

    cleaned = Rails.backtrace_cleaner.clean(e.backtrace)
    if cleaned.any?
      Rails.logger.error cleaned
    else
      Rails.logger.error e.backtrace.join("\n")
    end

    ExceptionNotifier.notify_exception(e) if Object.const_defined?(:ExceptionNotifier)
    PeakFlowUtils::Notifier.notify(error: e) if Object.const_defined?(:PeakFlowUtils)
    raise e
  end

  def self.execute_with_advisory_lock!(*args, **opts, &blk)
    # The difference between the stripe events is about a few milliseconds - with advisory_lock
    # we will prevent from creating duplicated objects due to race condition.
    # https://stripe.com/docs/webhooks/best-practices#event-ordering
    with_exception_notifications do
      StripeModelCallbacks::ApplicationRecord.with_advisory_lock(advisory_lock_name(*args, **opts)) do
        response = execute(*args, **opts, &blk)
        raise response.errors.join(". ") unless response.success?

        response
      end
    end
  end

  def self.advisory_lock_name(event:)
    stripe_event_data = event.data.object

    ["stripe", stripe_event_data.object, "id", advisory_lock_id(stripe_event_data)].join("-")
  end

  def self.advisory_lock_id(stripe_event_data)
    return stripe_event_data.id if stripe_event_data.respond_to?(:id)
    return stripe_event_data.coupon.id if stripe_event_data.object == "discount"
    return unless stripe_event_data.respond_to?(:customer)

    if stripe_event_data.customer.is_a?(String)
      stripe_event_data.customer
    else
      stripe_event_data.customer.id
    end
  end
end
