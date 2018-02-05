FactoryBot.define do
  factory :stripe_order, class: StripeModelCallbacks::StripeOrder do
    sequence(:identifier) { |n| "stripe-order-#{n}" }
    amount Money.new(1000, "USD")
    currency "usd"
    livemode false
    status "created"
  end
end
