FactoryBot.define do
  factory :stripe_product do
    sequence(:name) { |n| "Stripe product #{n}" }
    sequence(:stripe_id) { |n| "stripe-product-#{n}" }

    trait :with_stripe_mock do
      after :create do |stripe_product|
        mock_product = Stripe::Product.create(
          id: stripe_product.stripe_id,
          name: stripe_product.name,
          type: "service"
        )
        stripe_product.assign_from_stripe(mock_product)
        stripe_product.save!
      end
    end
  end
end
