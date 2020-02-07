FactoryBot.define do
  factory :stripe_order do
    sequence(:stripe_id) { |n| "stripe-order-#{n}" }
    amount { Money.new(1000, "USD") }
    currency { "usd" }
    livemode { false }
    status { "created" }
  end
end
