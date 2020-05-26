class StripeCustomer < StripeModelCallbacks::ApplicationRecord
  has_many :stripe_cards, primary_key: "stripe_id"
  has_many :stripe_charges, primary_key: "stripe_id"
  has_many :stripe_discounts, primary_key: "stripe_id"
  has_many :stripe_invoices, primary_key: "stripe_id"
  has_many :stripe_invoice_items, primary_key: "stripe_id"
  has_many :stripe_orders, primary_key: "stripe_id"
  has_many :stripe_subscriptions, primary_key: "stripe_id"
  has_many :stripe_subscription_schedules, primary_key: "stripe_id"

  def self.stripe_class
    Stripe::Customer
  end

  def assign_from_stripe(object)
    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self, stripe_model: object,
      attributes: %w[
        account_balance currency created default_source delinquent description discount email
        id livemode metadata
      ]
    )
  end
end
