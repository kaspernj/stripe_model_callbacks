class StripeSubscriptionSchedulePhasePlan < StripeModelCallbacks::ApplicationRecord
  belongs_to :stripe_subscription_schedule_phase, primary_key: "stripe_id"
end
