FactoryBot.define do
  factory :stripe_subscription_schedule do
    sequence(:stripe_id) { |n| "stripe-subscription-schedule-#{n}" }
  end
end
