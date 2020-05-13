FactoryBot.define do
  factory :subscription_schedule_phase_plan do
    sequence(:stripe_id) { |n| "stripe-subscription-schedule-phase-#{n}" }
    subscription_schedule_phase
  end
end
