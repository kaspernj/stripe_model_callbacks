FactoryBot.define do
  factory :stripe_invoice do
    sequence(:stripe_id) { |n| "stripe-invoice-#{n}" }
    amount_due_cents { 0 }
    amount_due_currency { "USD" }
    attempted { false }
    closed { false }
    collection_method { "charge_automatically" }
    created { 2.days.ago }
    currency { "usd" }
    forgiven { false }
    livemode { false }
    auto_advance { nil }
    paid { false }
    stripe_customer
  end
end
