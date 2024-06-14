FactoryBot.define do
  factory :stripe_payment_intent do
    amount { 125_00 }
    currency { "usd" }
    sequence(:stripe_id) { |n| "stripe-payment-intent-#{n}" }

    trait :with_conditional_stripe_mock do
      after :create do |stripe_payment_intent|
        stripe_payment_intent.create_stripe_mock! if StripeMock.instance
      end
    end

    trait :with_stripe_mock do
      after :create do |stripe_payment_intent|
        stripe_payment_intent.create_stripe_mock!
      end
    end
  end
end
