FactoryBot.define do
  factory :stripe_payment_intent do
    amount { 125_00 }
    currency { "usd" }
    sequence(:stripe_id) { |n| "stripe-payment-intent-#{n}" }

    trait :with_stripe_mock do
      after :create do |stripe_payment_intent|
        mock_payment_intent = Stripe::PaymentIntent.create(
          amount: stripe_payment_intent.amount,
          amount_capturable: stripe_payment_intent.amount_capturable,
          amount_details: stripe_payment_intent.amount_details,
          amount_received: stripe_payment_intent.amount_received,
          application: stripe_payment_intent.application,
          application_fee_amount: stripe_payment_intent.application_fee_amount,
          automatic_payment_methods: stripe_payment_intent.automatic_payment_methods,
          canceled_at: stripe_payment_intent.canceled_at,
          cancellation_reason: stripe_payment_intent.cancellation_reason,
          capture_method: stripe_payment_intent.capture_method,
          client_secret: stripe_payment_intent.client_secret,
          currency: stripe_payment_intent.currency,
          customer: stripe_payment_intent.customer,
          id: stripe_payment_intent.stripe_id,
          status: stripe_payment_intent.status
        )
        stripe_payment_intent.assign_from_stripe(mock_payment_intent)
        stripe_payment_intent.save!
      end
    end
  end
end
