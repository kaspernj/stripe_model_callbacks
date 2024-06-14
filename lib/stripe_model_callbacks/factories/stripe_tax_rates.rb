FactoryBot.define do
  factory :stripe_tax_rate do
    sequence(:stripe_id) { |n| "stripe-tax-rate-#{n}" }

    trait :with_stripe_mock do
      after :create do |stripe_tax_rate|
        mock_tax_rate = Stripe::TaxRate.create(
          id: stripe_tax_rate.stripe_id
        )
        stripe_tax_rate.assign_from_stripe(mock_tax_rate)
        stripe_tax_rate.save!
      end
    end
  end
end
