FactoryBot.define do
  factory :stripe_review do
    sequence(:stripe_id) { |n| "stripe-review-#{n}" }
    stripe_charge
  end
end
