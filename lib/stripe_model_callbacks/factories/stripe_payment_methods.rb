FactoryBot.define do
  factory :stripe_payment_method do
    sequence(:stripe_id) { |n| "stripe-payment-method-#{n}" }

    trait :with_stripe_mock do
      after :create do |stripe_payment_method|
        mock_payment_method = Stripe::PaymentMethod.create(customer: stripe_payment_method.customer, id: stripe_payment_method.stripe_id, type: "card")
        stripe_payment_method.assign_from_stripe(mock_payment_method)
        stripe_payment_method.save!
      end
    end
  end
end
