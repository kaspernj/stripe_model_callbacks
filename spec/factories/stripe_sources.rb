FactoryBot.define do
  factory :stripe_source do
    sequence(:stripe_id) { |n| "stripe-source-#{n}" }
    client_secret { "CLIENT-FAKE-SECRET" }
    flow { "receiver" }
    livemode { false }
  end
end
