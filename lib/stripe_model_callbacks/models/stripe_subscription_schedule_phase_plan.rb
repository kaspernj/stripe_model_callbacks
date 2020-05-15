class StripeSubscriptionSchedulePhasePlan < StripeModelCallbacks::ApplicationRecord
  belongs_to :stripe_subscription_schedule_phase, primary_key: "stripe_id"

  def assign_from_plan_hash(plan_hash)
    assign_billing_thresholds

    assign_attributes(
      stripe_plan_id: plan_hash.dig(:plan),
      stripe_price_id: plan_hash.dig(:price),
      quantity: plan_hash.dig(:quantity)
    )
  end

  def assign_billing_thresholds(phase_hash)
    billing_thresholds = phase_hash.dig(:billing_thresholds)

    self.billing_thresholds_usage_gte = billing_thresholds&.dig(:usage_gte)
  end
end
