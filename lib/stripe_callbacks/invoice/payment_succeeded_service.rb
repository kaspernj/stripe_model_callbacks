class StripeCallbacks::Invoice::PaymentSucceededService < StripeCallbacks::BaseEventService
  def execute!
    invoice = ::Invoice.new
    invoice.assign_from_stripe(object)

    object.lines.each do |stripe_invoice_line|
      # if invoice.new_record?
      #   invoice_line = invoice.invoice_lines.build(stripe_identifier: stripe_invoice_line.id)
      # else
        invoice_line = invoice.invoice_lines.find_or_initialize_by(stripe_identifier: stripe_invoice_line.id)
      # end

      invoice_line.assign_from_stripe(stripe_invoice_line)
    end

    if invoice.save
      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: invoice.errors.full_messages)
    end
  end
end
