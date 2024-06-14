FactoryBot.define do
  factory :stripe_subscription do
    sequence(:stripe_id) { |n| "stripe-subscription-#{n}" }
    billing { "charge_automatically" }
    cancel_at_period_end { false }
    created { Time.zone.now.beginning_of_month }
    current_period_start { Time.zone.now.beginning_of_month }
    current_period_end { Time.zone.now.end_of_month }
    stripe_customer
    livemode { false }
    stripe_plan
    start_date { 1.month.ago.beginning_of_month }

    trait :active do
      status { "active" }
    end

    trait :cancel_at_period_end do
      cancel_at_period_end { true }
    end

    trait :with_conditional_stripe_mock do
      association :stripe_customer, factory: [:stripe_customer, :with_conditional_stripe_mock]
      association :stripe_plan, factory: [:stripe_plan, :with_conditional_stripe_mock]

      after :create do |stripe_subscription|
        stripe_subscription.create_stripe_mock! if StripeMock.instance
      end
    end

    trait :with_stripe_mock do
      association :stripe_customer, factory: [:stripe_customer, :with_stripe_mock]
      association :stripe_plan, factory: [:stripe_plan, :with_stripe_mock]

      after :create, &:create_stripe_mock!
    end
  end
end
