FactoryBot.define do
  factory :stripe_refund do
    sequence(:identifier) { |n| "stripe-refund-#{n}" }
    association :charge, factory: :stripe_charge
    currency "usd"
    amount Money.new(1000, "USD")
    livemode false
  end
end
