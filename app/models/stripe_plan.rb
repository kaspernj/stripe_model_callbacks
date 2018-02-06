class StripePlan < StripeModelCallbacks::ApplicationRecord
  self.primary_key = "id"

  has_many :stripe_invoice_items, dependent: :restrict_with_error
  has_many :stripe_subscriptions, dependent: :restrict_with_error

  monetize :amount_cents

  def self.stripe_class
    Stripe::Plan
  end

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
