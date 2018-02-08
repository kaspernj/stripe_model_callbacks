FactoryBot.define do
  factory :stripe_bank_account do
    sequence(:id) { |n| "stripe-bank-account-#{n}" }
  end
end
