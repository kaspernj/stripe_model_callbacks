FactoryBot.define do
  factory :stripe_product do
    sequence(:id) { |n| "stripe-product-#{n}" }
  end
end
