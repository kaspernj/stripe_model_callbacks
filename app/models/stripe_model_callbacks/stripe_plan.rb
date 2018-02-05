class StripeModelCallbacks::StripePlan < StripeModelCallbacks::ApplicationRecord
  self.table_name = "stripe_plans"

  monetize :amount_cents

  def assign_from_stripe(object)
    assign_attributes(
      amount: Money.new(object.amount, object.currency),
      created_at: Time.zone.at(object.created),
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
