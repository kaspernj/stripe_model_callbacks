FactoryBot.define do
  factory :stripe_payment_method do
    sequence(:stripe_id) { |n| "stripe-payment-method-#{n}" }
  end
end
