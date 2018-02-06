class StripeCustomer < StripeModelCallbacks::ApplicationRecord
  self.primary_key = "id"

  has_many :stripe_charges, dependent: :restrict_with_error
  has_many :stripe_discounts, dependent: :restrict_with_error
  has_many :stripe_invoices, dependent: :restrict_with_error
  has_many :stripe_invoice_items, dependent: :restrict_with_error
  has_many :stripe_orders, dependent: :restrict_with_error
  has_many :stripe_subscriptions, dependent: :restrict_with_error

  def assign_from_stripe(object)
    assign_attributes(
      account_balance: object.account_balance,
      created: Time.zone.at(object.created),
      delinquent: object.delinquent,
      description: object.description,
      discount: object.discount,
      email: object.email,
      livemode: object.livemode,
      metadata: JSON.generate(object.metadata)
    )

    self.currency = object.currency if object.respond_to?(:currency)
  end
end
