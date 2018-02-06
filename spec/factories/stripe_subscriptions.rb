FactoryBot.define do
  factory :stripe_subscription do
    sequence(:id) { |n| "stripe-subscription-#{n}" }
    billing "charge_automatically"
    cancel_at_period_end false
    created Time.zone.now.beginning_of_month
    current_period_start Time.zone.now.beginning_of_month
    current_period_end Time.zone.now.end_of_month
    stripe_customer
    livemode false
    stripe_plan
    start 1.month.ago.beginning_of_month

    trait :active do
      status "active"
    end

    trait :with_stripe_mock do
      after :create do |stripe_subscription|
        mock_subscription = Stripe::Subscription.create(
          customer: stripe_subscription.stripe_customer.id,
          plan: stripe_subscription.stripe_plan.id
        )
        stripe_subscription.assign_from_stripe(mock_subscription)
        stripe_subscription.save!
      end
    end
  end
end
