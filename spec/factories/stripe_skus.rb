FactoryBot.define do
  factory :stripe_sku, class: StripeModelCallbacks::StripeSku do
    sequence(:identifier) { |n| "stripe-sku-#{n}" }
    price Money.new(10_000, "USD")
    currency "usd"
  end
end
