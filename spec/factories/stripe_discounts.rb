FactoryBot.define do
  factory :stripe_discount do
    association :coupon, factory: :stripe_coupon
    association :customer, factory: :stripe_customer
  end
end
