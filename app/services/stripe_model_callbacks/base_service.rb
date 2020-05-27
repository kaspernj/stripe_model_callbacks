class StripeModelCallbacks::BaseService < ServicePattern::Service
  def self.reported_execute!(*args, &blk)
    with_exception_notifications do
      response = execute(*args, &blk)
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

    ExceptionNotifier.notify_exception(e) if Object.const_defined?("ExceptionNotifier")
    raise e
  end

  def self.execute_with_advisory_lock!(*args, &blk)
    # The difference between the stripe events is about a few milliseconds - with advisory_lock
    # we will prevent from creating duplicated objects due to race condition.
    # https://stripe.com/docs/webhooks/best-practices#event-ordering
    with_exception_notifications do
      StripeModelCallbacks::ApplicationRecord.with_advisory_lock(advisory_lock_name(*args)) do
        response = execute(*args, &blk)
        raise response.errors.join(". ") unless response.success?

        response
      end
    end
  end

  def self.advisory_lock_name(*args)
    stripe_event_data = args.first[:event].data.object
    object_id = stripe_event_data.object == "discount" ? stripe_event_data.coupon.id : stripe_event_data.id

    ["stripe", stripe_event_data.object, "id", object_id].join("-")
  end
end
