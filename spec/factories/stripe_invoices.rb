FactoryBot.define do
  factory :stripe_invoice, class: StripeModelCallbacks::StripeInvoice do
    amount_due_cents 0
    amount_due_currency "USD"
    attempted false
    billing "charge_automatically"
    closed false
    currency "usd"
    date 2.days.ago
    forgiven false
    livemode false
    paid false

    association :customer, factory: :stripe_customer
  end
end
