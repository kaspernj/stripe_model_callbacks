FactoryBot.define do
  factory :stripe_payout do
    sequence(:identifier) { |n| "stripe-payout-#{n}" }
  end
end
