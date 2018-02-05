class StripeModelCallbacks::StripeCustomer < StripeModelCallbacks::ApplicationRecord
  self.table_name = "stripe_customers"

  belongs_to :subscription,
    class_name: "StripeModelCallbacks::StripeSubscription",
    foreign_key: "subscription_identifier",
    inverse_of: :customer,
    optional: true,
    primary_key: "identifier"

  has_many :charges,
    class_name: "StripeModelCallbacks::StripeCharge",
    dependent: :restrict_with_error,
    foreign_key: "customer_identifier",
    inverse_of: :customer,
    primary_key: "identifier"

  has_many :invoice_items,
    class_name: "StripeModelCallbacks::StripeInvoiceItem",
    dependent: :restrict_with_error,
    foreign_key: "customer_identifier",
    inverse_of: :customer,
    primary_key: "identifier"

  has_many :orders,
    class_name: "StripeModelCallbacks::StripeOrder",
    dependent: :restrict_with_error,
    foreign_key: "customer_identifier",
    inverse_of: :customer,
    primary_key: "identifier"

  def assign_from_stripe(object)
    assign_attributes(
      account_balance: object.account_balance,
      created_at: Time.zone.at(object.created),
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
