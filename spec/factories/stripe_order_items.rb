FactoryBot.define do
  factory :stripe_order_item do
    sequence(:parent_id) { |n| "stripe-order-line-#{n}" }
    stripe_order
    amount { Money.new(1000, "USD") }
    currency { "usd" }
  end
end
