FactoryBot.define do
  factory :stripe_recipient, class: StripeModelCallbacks::StripeRecipient do
    sequence(:identifier) { |n| "stripe-recipient-#{n}" }
  end
end
