FactoryBot.define do
  factory :stripe_subscription_item do
    sequence(:stripe_id) { |n| "stripe-subscription-item-#{n}" }
    stripe_subscription
    stripe_plan
    quantity { 1 }
  end
end
