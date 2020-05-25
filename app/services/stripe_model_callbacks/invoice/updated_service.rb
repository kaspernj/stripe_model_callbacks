class StripeModelCallbacks::Invoice::UpdatedService < StripeModelCallbacks::BaseEventService
  TRACKED_ACTIVITIES = {
    "invoice.payment_failed": :payment_failed,
    "invoice.payment_succeeded": :payment_succeeded,
    "invoice.sent": :sent,
    "invoice.upcoming": :upcoming
  }.freeze.with_indifferent_access
  private_constant :TRACKED_ACTIVITIES

  def execute
    invoice.assign_from_stripe(object)
    return success_actions if invoice.save

    fail!(invoice.errors.full_messages)
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
