FactoryBot.define do
  factory :stripe_coupon do
    sequence(:stripe_id) { |n| "stripe-coupon-#{n}" }

    trait :with_stripe_mock do
      duration { "repeating" }
      duration_in_months { 1 }

      after :create do |stripe_coupon|
        mock_coupon = Stripe::Coupon.create(
          duration: stripe_coupon.duration,
          duration_in_months: stripe_coupon.duration_in_months,
          id: stripe_coupon.stripe_id,
          percent_off: stripe_coupon.percent_off
        )
        stripe_coupon.assign_from_stripe(mock_coupon)
        stripe_coupon.save!
      end
    end
  end
end
