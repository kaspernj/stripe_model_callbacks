FactoryBot.define do
  factory :stripe_transfer do
    sequence(:id) { |n| "stripe-transfer-#{n}" }
    amount Money.new(10_000, "USD")
    amount_reversed Money.new(0, "USD")
    currency "usd"
  end
end
