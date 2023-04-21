FactoryBot.define do
  factory :stripe_payment_intent do
    sequence(:stripe_id) { |n| "stripe-payment-intent-#{n}" }
  end
end
