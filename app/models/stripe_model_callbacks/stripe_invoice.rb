class StripeModelCallbacks::StripeInvoice < StripeModelCallbacks::ApplicationRecord
  self.table_name = "stripe_invoices"

  belongs_to :subscription,
    class_name: "StripeModelCallbacks::StripeSubscription",
    foreign_key: "subscription_identifier",
    inverse_of: :invoices,
    optional: true,
    primary_key: "identifier"

  has_many :invoice_items,
    class_name: "StripeModelCallbacks::StripeInvoiceItem",
    dependent: :destroy,
    foreign_key: "invoice_identifier",
    inverse_of: :invoice,
    primary_key: "identifier"

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
      customer_identifier: object.customer,
      date: Time.zone.at(object.date),
      forgiven: object.forgiven,
      identifier: object.id,
      livemode: object.livemode,
      paid: object.paid
    )
  end
end
