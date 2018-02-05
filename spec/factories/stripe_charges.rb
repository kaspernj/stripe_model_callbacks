FactoryBot.define do
  factory :stripe_charge, class: StripeModelCallbacks::StripeCharge do
    amount Money.new(100, "USD")
    captured false
    currency "usd"
    livemode false
    paid false
    refunded false
  end
end
