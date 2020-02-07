FactoryBot.define do
  factory :stripe_subscription_item do
    sequence(:stripe_id) { |n| "stripe-subscription-item-#{n}" }
    stripe_subscription
    stripe_plan
    quantity { 1 }

    trait :with_stripe_mock do
      after :build do |item|
        mock_item = Stripe::SubscriptionItem.create(
          subscription: item.stripe_subscription.stripe_id,
          plan: item.stripe_plan.stripe_id,
          quantity: item.quantity
        )
        item.assign_from_stripe(mock_item)
      end
    end
  end
end
