class StripeSubscriptionSchedulePhase < StripeModelCallbacks::ApplicationRecord
  belongs_to :stripe_subscription_schedule, primary_key: "stripe_id"
end
