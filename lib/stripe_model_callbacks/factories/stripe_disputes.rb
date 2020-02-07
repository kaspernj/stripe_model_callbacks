FactoryBot.define do
  factory :stripe_dispute do
    sequence(:stripe_id) { |n| "stripe-dispute-#{n}" }
    amount { Money.new(1000, "USD") }
    currency { "usd" }
  end
end
