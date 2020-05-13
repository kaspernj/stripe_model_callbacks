class StripeSubscriptionSchedulePhase < StripeModelCallbacks::ApplicationRecord
  belongs_to :stripe_subscription_schedule, primary_key: "stripe_id"

  has_many :subscription_schedule_phase_plans, primary_key: "stripe_id"
end
