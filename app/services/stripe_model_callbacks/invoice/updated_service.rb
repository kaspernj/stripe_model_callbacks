class StripeModelCallbacks::Invoice::UpdatedService < StripeModelCallbacks::BaseEventService
  def perform
    invoice.assign_from_stripe(object)

    if invoice.save
      create_activity

      succeed!
    else
      fail! invoice.errors.full_messages
    end
  end

private

  def create_activity
    invoice.try(:create_activity, :payment_failed) if event.type == "invoice.payment_failed"
    invoice.try(:create_activity, :payment_succeeded) if event.type == "invoice.payment_succeeded"
    invoice.try(:create_activity, :sent) if event.type == "invoice.sent"
    invoice.try(:create_activity, :upcoming) if event.type == "invoice.upcoming"
  end

  def invoice
    @invoice ||= StripeInvoice.find_or_initialize_by(stripe_id: object.id)
  end
end
