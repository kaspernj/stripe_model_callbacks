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
    invoice.create_audit!(action: :payment_failed) if event.type == "invoice.payment_failed"
    invoice.create_audit!(action: :payment_succeeded) if event.type == "invoice.payment_succeeded"
    invoice.create_audit!(action: :sent) if event.type == "invoice.sent"
    invoice.create_audit!(action: :upcoming) if event.type == "invoice.upcoming"
  end

  def invoice
    @invoice ||= StripeInvoice.find_or_initialize_by(stripe_id: object.id)
  end
end
