FactoryBot.define do
  factory :stripe_charge do
    sequence(:stripe_id) { |n| "stripe-charge-#{n}" }
    amount { Money.new(100, "USD") }
    captured { false }
    currency { "usd" }
    livemode { false }
    paid { false }
    refunded { false }
  end
end
