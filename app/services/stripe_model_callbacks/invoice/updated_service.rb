class StripeModelCallbacks::Invoice::UpdatedService < StripeModelCallbacks::BaseEventService
  ACTIVITY_TYPES = {
    "invoice.payment_failed": :payment_failed,
    "invoice.payment_succeeded": :payment_succeeded,
    "invoice.sent": :sent,
    "invoice.upcoming": :upcoming
  }.freeze.with_indifferent_access
  private_constant :ACTIVITY_TYPES

  def execute
  invoice.assign_from_stripe(object)
  return success_actions if invoice.save

  fail!(invoice.errors.full_messages)
  rescue ActiveRecord::RecordNotUnique, PG::UniqueViolation, SQLite3::ConstraintException
    return succeed! if event.type == "invoice.created"

    raise ActiveRecord::RecordNotUnique
  end

private

  def success_actions
    create_activity
    succeed!
  end

  def create_activity
    invoice.create_activity(ACTIVITY_TYPES[event.type]) if ACTIVITY_TYPES.fetch(event.type, nil)
  end

  def invoice
    @invoice ||= StripeInvoice.find_or_initialize_by(stripe_id: object.id)
  end
end
