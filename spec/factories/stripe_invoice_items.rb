FactoryBot.define do
  factory :stripe_invoice_item do
    sequence(:id) { |n| "stripe-invoice-item-#{n}" }
    amount Money.new(1_000, "USD")
    stripe_invoice
    currency "usd"
    discountable false
    proration false
    sequence(:description) { |n| "Test #{n}" }
  end
end
