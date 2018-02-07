FactoryBot.define do
  factory :stripe_subscription_item do
    stripe_subscription
    stripe_plan
    quantity 1
  end
end
