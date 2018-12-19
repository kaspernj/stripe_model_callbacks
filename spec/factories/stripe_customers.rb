FactoryBot.define do
  factory :stripe_customer do
    sequence(:stripe_id) { |n| "customer-identifier-#{n}" }
    account_balance { 0 }
    currency { "usd" }
    delinquent { false }
    livemode { false }

    trait :with_stripe_mock do
      after :create do |stripe_customer|
        mock_customer = Stripe::Customer.create(source: StripeMock.create_test_helper.generate_card_token)
        stripe_customer.assign_from_stripe(mock_customer)
        stripe_customer.save!
      end
    end
  end
end
