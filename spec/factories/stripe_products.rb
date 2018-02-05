FactoryBot.define do
  factory :stripe_product, class: StripeModelCallbacks::StripeProduct do
    sequence(:identifier) { |n| "stripe-product-#{n}" }
  end
end
