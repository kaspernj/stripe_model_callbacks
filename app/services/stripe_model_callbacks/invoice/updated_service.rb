class StripeModelCallbacks::Invoice::UpdatedService < StripeModelCallbacks::BaseEventService
  TRACKED_ACTIVITIES = {
    "invoice.payment_failed": :payment_failed,
    "invoice.payment_succeeded": :payment_succeeded,
    "invoice.sent": :sent,
    "invoice.upcoming": :upcoming
  }.freeze.with_indifferent_access
  private_constant :TRACKED_ACTIVITIES

  def execute
    # The difference between the stripe events is about a few milliseconds - with advisory_lock
    # we will prevent from creating invoice duplicates due to race condition.
    # https://stripe.com/docs/webhooks/best-practices#event-ordering
    StripeModelCallbacks::ApplicationRecord.with_advisory_lock("stripe_invoice-id#{object.id}") do
      invoice.assign_from_stripe(object)
      return success_actions if invoice.save

      fail!(invoice.errors.full_messages)
    end
  end

private

  def success_actions
    create_activity
    succeed!
  end

  def create_activity
    return unless tracked_activities[event.type]

    invoice.create_activity(tracked_activities[event.type])
  end

  def tracked_activities
    TRACKED_ACTIVITIES
  end

  def invoice
    @invoice ||= StripeInvoice.find_or_initialize_by(stripe_id: object.id)
  end
end
