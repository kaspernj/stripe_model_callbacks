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
    start { 1.month.ago.beginning_of_month }

    trait :active do
      status { "active" }
    end

    trait :cancel_at_period_end do
      cancel_at_period_end { true }
    end

    trait :with_stripe_mock do
      association :stripe_customer, factory: [:stripe_customer, :with_stripe_mock]
      association :stripe_plan, factory: [:stripe_plan, :with_stripe_mock]

      after :create do |stripe_subscription|
        cancel_at_period_end = stripe_subscription.cancel_at_period_end?

        mock_subscription = Stripe::Subscription.create(
          customer: stripe_subscription.stripe_customer.stripe_id,
          plan: stripe_subscription.stripe_plan.stripe_id
        )
        stripe_subscription.assign_from_stripe(mock_subscription)
        stripe_subscription.save!

        stripe_subscription.cancel!(at_period_end: true) if cancel_at_period_end
      end
    end
  end
end
