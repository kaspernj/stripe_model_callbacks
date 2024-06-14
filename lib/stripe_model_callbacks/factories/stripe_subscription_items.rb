FactoryBot.define do
  factory :stripe_subscription_item do
    sequence(:stripe_id) { |n| "stripe-subscription-item-#{n}" }
    stripe_subscription
    stripe_plan
    quantity { 1 }

    trait :with_conditional_stripe_mock
      after :build do |item|
        item.create_stripe_mock! if StripeMock.instance
      end
    end

    trait :with_stripe_mock do
      after :build do |item|
        item.create_stripe_mock!
      end
    end
  end
end
