class StripeModelCallbacks::Invoice::UpdatedService < StripeModelCallbacks::BaseEventService
  def execute!
    invoice = StripeModelCallbacks::StripeInvoice.find_or_initialize_by(identifier: object.id)
    invoice.assign_from_stripe(object)

    if invoice.save
      object.lines.each do |stripe_invoice_line|
        invoice_line = StripeModelCallbacks::StripeInvoiceItem.find_or_initialize_by(identifier: stripe_invoice_line.id)
        invoice_line.assign_from_stripe(stripe_invoice_line)
        invoice_line.invoice_identifier = object.id
        invoice_line.save!
      end

      invoice.create_activity :payment_failed if event.type == "invoice.payment_failed"
      invoice.create_activity :payment_succeeded if event.type == "invoice.payment_succeeded"
      invoice.create_activity :sent if event.type == "invoice.sent"
      invoice.create_activity :upcoming if event.type == "invoice.upcoming"

      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: invoice.errors.full_messages)
    end
  end
end
