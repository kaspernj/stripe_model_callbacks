class StripeSubscriptionSchedule < StripeModelCallbacks::ApplicationRecord
  has_many :subscription_schedule_phases, primary_key: "stripe_id"
end
