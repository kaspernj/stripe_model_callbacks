FactoryBot.define do
  factory :stripe_recipient do
    sequence(:identifier) { |n| "stripe-recipient-#{n}" }
  end
end
