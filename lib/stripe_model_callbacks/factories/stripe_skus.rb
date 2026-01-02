FactoryBot.define do
  factory :stripe_sku do
    sequence(:stripe_id) { |n| "stripe-sku-#{n}" }
    active { false }
    price { Money.new(10_000, "USD") }
    currency { "usd" }
  end
end
