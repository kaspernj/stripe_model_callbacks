FactoryBot.define do
  factory :stripe_coupon do
    sequence(:id) { |n| "stripe-coupon-#{n}" }
  end
end
