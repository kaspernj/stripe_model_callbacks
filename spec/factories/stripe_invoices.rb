FactoryBot.define do
  factory :stripe_invoice do
    sequence(:stripe_id) { |n| "stripe-invoice-#{n}" }
    amount_due_cents { 0 }
    amount_due_currency { "USD" }
    attempted { false }
    billing { "charge_automatically" }
    closed { false }
    created { 2.days.ago }
    currency { "usd" }
    forgiven { false }
    livemode { false }
    paid { false }
    stripe_customer
  end
end
