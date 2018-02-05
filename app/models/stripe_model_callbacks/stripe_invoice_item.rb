class StripeModelCallbacks::StripeInvoiceItem < StripeModelCallbacks::ApplicationRecord
  self.table_name = "stripe_invoice_items"

  belongs_to :customer,
    class_name: "StripeModelCallbacks::StripeCustomer",
    foreign_key: "customer_identifier",
    inverse_of: :invoice_items,
    optional: true,
    primary_key: "identifier"

  belongs_to :invoice,
    class_name: "StripeModelCallbacks::StripeInvoice",
    foreign_key: "invoice_identifier",
    inverse_of: :invoice_items,
    optional: true,
    primary_key: "identifier"

  belongs_to :plan,
    class_name: "StripeModelCallbacks::StripePlan",
    foreign_key: "plan_identifier",
    inverse_of: :invoice_items,
    optional: true,
    primary_key: "identifier"

  monetize :amount_cents

  def assign_from_stripe(object)
    assign_attributes(
      amount: Money.new(object.amount, object.currency),
      currency: object.currency,
      customer_identifier: object.try(:customer),
      description: object.description,
      discountable: object.discountable,
      livemode: object.livemode,
      metadata: JSON.generate(object.metadata),
      period_start: Time.zone.at(object.period.start),
      period_end: Time.zone.at(object.period.end),
      plan_identifier: object.plan&.id,
      proration: object.proration,
      quantity: object.quantity,
      subscription_identifier: object.subscription,
      subscription_item: object.try(:subscription_item)
    )
  end
end
