class StripeCustomer < StripeModelCallbacks::ApplicationRecord
  self.primary_key = "id"

  has_many :stripe_charges, dependent: :restrict_with_error
  has_many :stripe_discounts, dependent: :restrict_with_error
  has_many :stripe_invoices, dependent: :restrict_with_error
  has_many :stripe_invoice_items, dependent: :restrict_with_error
  has_many :stripe_orders, dependent: :restrict_with_error
  has_many :stripe_subscriptions, dependent: :restrict_with_error

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
