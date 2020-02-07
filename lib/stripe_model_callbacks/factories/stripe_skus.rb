FactoryBot.define do
  factory :stripe_sku do
    sequence(:stripe_id) { |n| "stripe-sku-#{n}" }
    price { Money.new(10_000, "USD") }
    currency { "usd" }
  end
end
