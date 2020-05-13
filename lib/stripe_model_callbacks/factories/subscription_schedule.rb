FactoryBot.define do
  factory :subscription_schedule do
    sequence(:stripe_id) { |n| "stripe-subscription-schedule-#{n}" }
  end
end
