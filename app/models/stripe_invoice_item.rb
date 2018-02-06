class StripeInvoiceItem < StripeModelCallbacks::ApplicationRecord
  self.primary_key = "id"

  belongs_to :stripe_customer,
    class_name: "StripeCustomer",
    foreign_key: "customer_id",
    inverse_of: :invoice_items,
    optional: true

  belongs_to :stripe_invoice,
    class_name: "StripeInvoice",
    foreign_key: "invoice_id",
    inverse_of: :invoice_items,
    optional: true

  belongs_to :stripe_plan,
    class_name: "StripePlan",
    foreign_key: "plan_id",
    inverse_of: :invoice_items,
    optional: true

  monetize :amount_cents

  def assign_from_stripe(object)
    assign_attributes(
      amount: Money.new(object.amount, object.currency),
      currency: object.currency,
      customer_id: object.try(:customer),
      description: object.description,
      discountable: object.discountable,
      livemode: object.livemode,
      metadata: JSON.generate(object.metadata),
      period_start: Time.zone.at(object.period.start),
      period_end: Time.zone.at(object.period.end),
      plan_id: object.plan&.id,
      proration: object.proration,
      quantity: object.quantity,
      subscription_id: object.subscription,
      subscription_item: object.try(:subscription_item)
    )
  end
end
