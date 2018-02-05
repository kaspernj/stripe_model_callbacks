FactoryBot.define do
  factory :stripe_plan, class: StripeModelCallbacks::StripePlan do
    sequence(:identifier) { |n| "stripe-plan-#{n}" }
    amount_cents 10_000
    amount_currency "USD"
    currency "usd"
    interval "months"
    interval_count 1
    livemode false
    sequence(:name) { |n| "Plan #{n}" }
  end
end
