class StripeCallbacks::InvoiceItem::CreatedService < StripeCallbacks::BaseEventService
  def execute!
    raise "stub"
  end

private

  def invoice
    @_invoice ||= Invoice.find_by!(stripe_identifier: object.invoice) if object.invoice
  end
end
