class StripeModelCallbacks::InvoiceItem::UpdatedService < StripeModelCallbacks::BaseEventService
  def perform
    invoice_item = ::StripeInvoiceItem.find_or_initialize_by(stripe_id: object.id)
    invoice_item.assign_from_stripe(object)
    invoice_item.deleted_at = Time.zone.now if event.type == "invoiceitem.deleted"

    if invoice_item.save
      succeed!
    else
      fail! invoice_item.errors.full_messages
    end
  end
end
