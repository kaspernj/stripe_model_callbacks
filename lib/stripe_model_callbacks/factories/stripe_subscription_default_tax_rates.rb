FactoryBot.define do
  factory :stripe_subscription_default_tax_rate do
    stripe_subscription
    stripe_tax_rate
  end
end
