FactoryBot.define do
  factory :stripe_review do
    sequence(:stripe_id) { |n| "stripe-review-#{n}" }
    stripe_charge
    livemode { false }
    open { true }
  end
end
