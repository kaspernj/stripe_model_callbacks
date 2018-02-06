FactoryBot.define do
  factory :stripe_payout do
    sequence(:id) { |n| "stripe-payout-#{n}" }
  end
end
