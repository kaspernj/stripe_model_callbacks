class StripePlan < StripeModelCallbacks::ApplicationRecord
  self.primary_key = "id"

  has_many :stripe_invoice_items,
    class_name: "StripeInvoiceItem",
    dependent: :restrict_with_error,
    foreign_key: "plan_id",
    inverse_of: :plan

  has_many :stripe_subscriptions,
    class_name: "StripeSubscription",
    dependent: :restrict_with_error,
    foreign_key: "plan_id",
    inverse_of: :plan

  monetize :amount_cents

  def assign_from_stripe(object)
    assign_attributes(
      amount: Money.new(object.amount, object.currency),
      created: Time.zone.at(object.created),
      currency: object.currency,
      interval: object.interval,
      interval_count: object.interval_count,
      livemode: object.livemode,
      metadata: JSON.generate(object.metadata),
      name: object.name,
      statement_descriptor: object.statement_descriptor,
      trial_period_days: object.trial_period_days
    )
  end
end
