FactoryBot.define do
  factory :stripe_payment_method do
    sequence(:stripe_id) { |n| "stripe-payment-method-#{n}" }

    trait :with_conditional_stripe_mock do
      after :create do |stripe_payment_method|
        stripe_payment_method.create_stripe_mock! if StripeMock.instance
      end
    end

    trait :with_stripe_mock do
      after :create, &:create_stripe_mock!
    end
  end
end
