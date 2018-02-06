FactoryBot.define do
  factory :stripe_refund do
    sequence(:id) { |n| "stripe-refund-#{n}" }
    stripe_charge
    currency "usd"
    amount Money.new(1000, "USD")
    livemode false
  end
end
