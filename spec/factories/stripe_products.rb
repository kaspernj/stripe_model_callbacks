FactoryBot.define do
  factory :stripe_product do
    sequence(:identifier) { |n| "stripe-product-#{n}" }
  end
end
