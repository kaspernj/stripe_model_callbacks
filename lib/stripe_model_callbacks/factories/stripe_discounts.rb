FactoryBot.define do
  factory :stripe_discount do
    stripe_coupon
    stripe_customer
  end
end
