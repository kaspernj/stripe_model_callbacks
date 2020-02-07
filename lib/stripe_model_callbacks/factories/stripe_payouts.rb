FactoryBot.define do
  factory :stripe_payout do
    sequence(:stripe_id) { |n| "stripe-payout-#{n}" }
  end
end
