FactoryBot.define do
  factory :stripe_card do
    sequence(:id) { |n| "stripe-card-#{n}" }
    last4 "4242"
    stripe_customer
  end
end
