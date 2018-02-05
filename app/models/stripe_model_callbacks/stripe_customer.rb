class StripeModelCallbacks::StripeCustomer < StripeModelCallbacks::ApplicationRecord
  self.table_name = "stripe_customers"

  has_many :invoice_items,
    class_name: "StripeModelCallbacks::StripeInvoiceItem",
    foreign_key: "customer_identifier",
    primary_key: "identifier"

  def assign_from_stripe(object)
    assign_attributes(
      created_at: Time.zone.at(object.created),
      email: object.email
    )
  end
end
