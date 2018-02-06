class StripeInvoice < StripeModelCallbacks::ApplicationRecord
  self.primary_key = "id"

  belongs_to :stripe_subscription, inverse_of: :stripe_invoices, optional: true
  has_many :stripe_invoice_items, dependent: :destroy

  monetize :amount_due_cents
  monetize :application_fee_cents

  def assign_from_stripe(object)
    assign_attributes(
      amount_due: Money.new(object.amount_due, object.currency),
      application_fee: object.application_fee ? Money.new(object.application_fee, object.currency) : nil,
      attempted: object.attempted,
      billing: object.billing,
      closed: object.closed,
      currency: object.currency,
      stripe_customer_id: object.customer,
      date: Time.zone.at(object.date),
      forgiven: object.forgiven,
      id: object.id,
      livemode: object.livemode,
      paid: object.paid
    )
  end
end
