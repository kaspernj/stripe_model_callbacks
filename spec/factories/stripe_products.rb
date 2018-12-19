FactoryBot.define do
  factory :stripe_product do
    sequence(:stripe_id) { |n| "stripe-product-#{n}" }
  end
end
