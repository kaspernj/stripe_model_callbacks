class StripeModelCallbacks::Invoice::PaymentSucceededService < StripeModelCallbacks::BaseEventService
  def execute!
    invoice = StripeModelCallbacks::StripeInvoice.new
    invoice.assign_from_stripe(object)

    if invoice.save
      object.lines.each do |stripe_invoice_line|
        invoice_line = StripeModelCallbacks::StripeInvoiceItem.find_or_initialize_by(identifier: stripe_invoice_line.id)
        invoice_line.assign_from_stripe(stripe_invoice_line)
        invoice_line.invoice_identifier = object.id
        invoice_line.save!
      end

      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: invoice.errors.full_messages)
    end
  end
end
