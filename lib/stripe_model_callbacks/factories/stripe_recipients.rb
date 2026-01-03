FactoryBot.define do
  factory :stripe_recipient do
    sequence(:stripe_id) { |n| "stripe-recipient-#{n}" }
    livemode { false }
    verified { false }
  end
end
