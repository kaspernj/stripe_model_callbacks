class StripeModelCallbacks::Invoice::UpdatedService < StripeModelCallbacks::BaseEventService
  def execute
  invoice.assign_from_stripe(object)
  return success_actions if invoice.save

  fail!(invoice.errors.full_messages)
  rescue ActiveRecord::RecordNotUnique, PG::UniqueViolation
    return succeed! if event.type == "invoice.created"

    raise ActiveRecord::RecordNotUnique
  end

private

  def create_activity
    invoice.create_activity :payment_failed if event.type == "invoice.payment_failed"
    invoice.create_activity :payment_succeeded if event.type == "invoice.payment_succeeded"
    invoice.create_activity :sent if event.type == "invoice.sent"
    invoice.create_activity :upcoming if event.type == "invoice.upcoming"
  end

  def invoice
    @invoice ||= StripeInvoice.find_or_initialize_by(stripe_id: object.id)
  end

  def success_actions
    create_activity
    succeed!
  end
end
