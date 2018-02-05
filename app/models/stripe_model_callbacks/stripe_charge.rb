class StripeModelCallbacks::StripeCharge < StripeModelCallbacks::ApplicationRecord
  self.table_name = "stripe_charges"

  belongs_to :customer,
    class_name: "StripeModelCallbacks::StripeCustomer",
    foreign_key: "customer_identifier",
    optional: true,
    primary_key: "identifier"

  def assign_from_stripe(object)
    assign_attributes(
      created_at: Time.zone.at(object.created)
    )
  end
end
