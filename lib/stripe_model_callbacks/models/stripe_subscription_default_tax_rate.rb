class StripeSubscriptionDefaultTaxRate < StripeModelCallbacks::ApplicationRecord
  belongs_to :stripe_subscription
  belongs_to :stripe_tax_rate
end
