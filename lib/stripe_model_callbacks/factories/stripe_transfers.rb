FactoryBot.define do
  factory :stripe_transfer do
    sequence(:stripe_id) { |n| "stripe-transfer-#{n}" }
    amount { Money.new(10_000, "USD") }
    amount_reversed { Money.new(0, "USD") }
    currency { "usd" }
    livemode { false }
    reversed { false }
  end
end
