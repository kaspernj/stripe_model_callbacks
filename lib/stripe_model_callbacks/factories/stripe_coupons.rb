FactoryBot.define do
  factory :stripe_coupon do
    sequence(:stripe_id) { |n| "stripe-coupon-#{n}" }
  end
end
