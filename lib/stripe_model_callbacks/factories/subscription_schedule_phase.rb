FactoryBot.define do
  factory :subscription_schedule_phase do
    sequence(:stripe_id) { |n| "stripe-subscription-schedule-phase-#{n}" }
    subscription_schedule
  end
end
