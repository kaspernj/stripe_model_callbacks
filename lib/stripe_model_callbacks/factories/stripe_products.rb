FactoryBot.define do
  factory :stripe_product do
    sequence(:name) { |n| "Stripe product #{n}" }
    sequence(:stripe_id) { |n| "stripe-product-#{n}" }
    active { false }
    livemode { false }
    shippable { false }

    trait :with_conditional_stripe_mock do
      after :create do |stripe_product|
        stripe_product.create_stripe_mock! if StripeMock.instance
      end
    end

    trait :with_stripe_mock do
      after :create, &:create_stripe_mock!
    end
  end
end
