class StripeModelCallbacks::Invoice::UpdatedService < StripeModelCallbacks::BaseEventService
  def execute!
    invoice.assign_from_stripe(object)

    if invoice.save
      create_invoice_items
      create_activity

      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: invoice.errors.full_messages)
    end
  end

private

  def create_activity
    invoice.create_activity :payment_failed if event.type == "invoice.payment_failed"
    invoice.create_activity :payment_succeeded if event.type == "invoice.payment_succeeded"
    invoice.create_activity :sent if event.type == "invoice.sent"
    invoice.create_activity :upcoming if event.type == "invoice.upcoming"
  end

  def create_invoice_items
    object.lines.each do |stripe_invoice_item|
      invoice_item = StripeInvoiceItem.find_or_initialize_by(id: stripe_invoice_item.id)
      invoice_item.assign_from_stripe(stripe_invoice_item)
      invoice_item.stripe_invoice_id = object.id
      invoice_item.save!
    end
  end

  def invoice
    @_invoice ||= StripeInvoice.find_or_initialize_by(id: object.id)
  end
end
