class StripeModelCallbacks::InvoiceItem::UpdatedService < StripeModelCallbacks::BaseEventService
  def execute!
    invoice_item = ::StripeModelCallbacks::StripeInvoiceItem.find_or_initialize_by(identifier: object.id)
    invoice_item.assign_from_stripe(object)
    invoice_item.deleted_at = Time.zone.now if event.type == "invoiceitem.deleted"

    if invoice_item.save
      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: invoice_item.errors.full_messages)
    end
  end
end
