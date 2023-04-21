FactoryBot.define do
  factory :stripe_setup_intent do
    sequence(:stripe_id) { |n| "stripe-setup-intent-#{n}" }
    stripe_customer
    livemode { false }
  end
end
