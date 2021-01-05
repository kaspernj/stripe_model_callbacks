FactoryBot.define do
  factory :stripe_tax_rate do
    sequence(:stripe_id) { |n| "stripe-tax-rate-#{n}" }
  end
end
