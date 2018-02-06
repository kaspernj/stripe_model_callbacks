FactoryBot.define do
  factory :stripe_coupon do
    sequence(:identifier) { |n| "stripe-coupon-#{n}" }
  end
end
