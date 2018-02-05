class StripeModelCallbacks::StripeCustomer < StripeModelCallbacks::ApplicationRecord
  self.table_name = "stripe_customers"

  belongs_to :subscription,
    class_name: "StripeModelCallbacks::StripeSubscription",
    foreign_key: "subscription_identifier",
    optional: true,
    primary_key: "identifier"

  has_many :invoice_items,
    class_name: "StripeModelCallbacks::StripeInvoiceItem",
    foreign_key: "customer_identifier",
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
