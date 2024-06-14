FactoryBot.define do
  factory :stripe_tax_rate do
    sequence(:stripe_id) { |n| "stripe-tax-rate-#{n}" }

    trait :with_conditional_stripe_mock do
      after :create do |stripe_tax_rate|
        stripe_tax_rate.create_stripe_mock! if StripeMock.instance
      end
    end

    trait :with_stripe_mock do
      after :create, &:create_stripe_mock!
    end
  end
end
