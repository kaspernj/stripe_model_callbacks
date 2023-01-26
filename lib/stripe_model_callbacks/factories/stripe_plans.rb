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

    trait :with_stripe_mock do
      association :stripe_product, factory: [:stripe_product, :with_stripe_mock]

      after :create do |stripe_plan|
        mock_plan = Stripe::Plan.create(
          id: stripe_plan.stripe_id,
          amount: stripe_plan.amount_cents,
          currency: stripe_plan.currency,
          interval: stripe_plan.interval,
          interval_count: stripe_plan.interval_count,
          product: stripe_plan.stripe_product.stripe_id
        )
        stripe_plan.assign_from_stripe(mock_plan)
        stripe_plan.save!
      end
    end
  end
end
