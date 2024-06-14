FactoryBot.define do
  factory :stripe_plan do
    sequence(:stripe_id) { |n| "stripe_plan_#{n}" }
    amount_cents { 10_000 }
    amount_currency { "USD" }
    currency { "usd" }
    interval { "month" }
    interval_count { 1 }
    livemode { false }
    stripe_product

    trait :with_conditional_stripe_mock do
      association :stripe_product, factory: [:stripe_product, :with_conditional_stripe_mock]

      after :create do |stripe_plan|
        stripe_plan.create_stripe_mock! if StripeMock.instance
      end
    end

    trait :with_stripe_mock do
      association :stripe_product, factory: [:stripe_product, :with_stripe_mock]

      after :create do |stripe_plan|
        stripe_plan.create_stripe_mock!
      end
    end
  end
end
