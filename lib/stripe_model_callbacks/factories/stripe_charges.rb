FactoryBot.define do
  factory :stripe_charge do
    sequence(:stripe_id) { |n| "stripe-charge-#{n}" }
    amount { Money.new(100, "USD") }
    captured { false }
    currency { "usd" }
    livemode { false }
    paid { false }
    refunded { false }

    trait :with_stripe_mock do
      after :create do |stripe_charge|
        mock_charge = Stripe::Charge.create(
          amount: stripe_charge.amount_cents,
          captured: stripe_charge.captured,
          currency: stripe_charge.currency,
          customer: stripe_charge.stripe_customer_id,
          id: stripe_charge.stripe_id,
          paid: stripe_charge.paid,
          refunded: stripe_charge.refunded
        )
        stripe_charge.assign_from_stripe(mock_charge)
        stripe_charge.save!
      end
    end
  end
end
