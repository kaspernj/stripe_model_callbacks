FactoryBot.define do
  factory :stripe_charge do
    sequence(:stripe_id) { |n| "stripe-charge-#{n}" }
    amount { Money.new(100, "USD") }
    captured { false }
    currency { "usd" }
    livemode { false }
    paid { false }
    refunded { false }

    trait :with_conditional_stripe_mock do
      after :create do |stripe_charge|
        stripe_charge.create_stripe_mock! if StripeMock.instance
      end
    end

    trait :with_stripe_mock do
      after :create, &:create_stripe_mock!
    end
  end
end
