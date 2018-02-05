FactoryBot.define do
  factory :stripe_order_item, class: StripeModelCallbacks::StripeOrderItem do
    sequence(:parent_identifier) { |n| "stripe-order-line-#{n}" }
    association :order, factory: :stripe_order
    amount Money.new(1000, "USD")
    currency "usd"
  end
end
