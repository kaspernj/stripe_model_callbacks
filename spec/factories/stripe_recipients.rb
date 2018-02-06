FactoryBot.define do
  factory :stripe_recipient do
    sequence(:id) { |n| "stripe-recipient-#{n}" }
  end
end
