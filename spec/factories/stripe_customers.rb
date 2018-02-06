FactoryBot.define do
  factory :stripe_customer do
    sequence(:id) { |n| "customer-identifier-#{n}" }
    account_balance 0
    currency "usd"
    delinquent false
    livemode false
  end
end
