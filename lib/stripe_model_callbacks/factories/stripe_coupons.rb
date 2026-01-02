FactoryBot.define do
  factory :stripe_coupon do
    sequence(:stripe_id) { |n| "stripe-coupon-#{n}" }
    livemode { false }

    trait :with_conditional_stripe_mock do
      duration { "repeating" }
      duration_in_months { 1 }

      after :create do |stripe_coupon|
        stripe_coupon.create_stripe_mock! if StripeMock.instance
      end
    end

    trait :with_stripe_mock do
      duration { "repeating" }
      duration_in_months { 1 }

      after :create, &:create_stripe_mock!
    end
  end
end
