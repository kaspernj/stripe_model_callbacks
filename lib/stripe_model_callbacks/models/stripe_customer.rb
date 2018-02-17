class StripeCustomer < StripeModelCallbacks::ApplicationRecord
  self.primary_key = "id"

  has_many :stripe_cards
  has_many :stripe_charges
  has_many :stripe_discounts
  has_many :stripe_invoices
  has_many :stripe_invoice_items
  has_many :stripe_orders
  has_many :stripe_subscriptions

  def self.stripe_class
    Stripe::Customer
  end

  def assign_from_stripe(object)
    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self, stripe_model: object,
      attributes: %w[
        account_balance currency created delinquent description discount email id
        livemode metadata
      ]
    )
  end
end
