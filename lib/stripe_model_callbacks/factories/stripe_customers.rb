FactoryBot.define do
  factory :stripe_customer do
    sequence(:stripe_id) { |n| "customer-identifier-#{n}" }
    balance { 0 }
    currency { "usd" }
    delinquent { false }
    livemode { false }

    trait :with_conditional_stripe_mock do
      after :create do |stripe_customer|
        stripe_customer.create_stripe_mock! if StripeMock.instance
      end
    end

    trait :with_stripe_mock do
      after :create, &:create_stripe_mock!
    end
  end
end
