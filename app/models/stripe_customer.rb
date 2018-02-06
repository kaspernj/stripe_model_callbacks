class StripeCustomer < StripeModelCallbacks::ApplicationRecord
  self.primary_key = "id"

  belongs_to :stripe_subscription,
    class_name: "StripeSubscription",
    foreign_key: "subscription_id",
    inverse_of: :customer,
    optional: true

  has_many :stripe_charges,
    class_name: "StripeCharge",
    dependent: :restrict_with_error,
    foreign_key: "customer_id",
    inverse_of: :customer

  has_many :stripe_discounts,
    class_name: "StripeDiscount",
    dependent: :restrict_with_error,
    foreign_key: "customer_id",
    inverse_of: :customer

  has_many :stripe_invoice_items,
    class_name: "StripeInvoiceItem",
    dependent: :restrict_with_error,
    foreign_key: "customer_id",
    inverse_of: :customer

  has_many :stripe_orders,
    class_name: "StripeOrder",
    dependent: :restrict_with_error,
    foreign_key: "customer_id",
    inverse_of: :customer

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
