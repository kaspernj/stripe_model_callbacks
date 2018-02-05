class StripeModelCallbacks::StripeOrder < StripeModelCallbacks::ApplicationRecord
  self.table_name = "stripe_orders"

  belongs_to :charge,
    class_name: "StripeModelCallbacks::StripeCharge",
    foreign_key: "charge_identifier",
    optional: true,
    primary_key: "identifier"

  belongs_to :customer,
    class_name: "StripeModelCallbacks::StripeCustomer",
    foreign_key: "customer_identifier",
    optional: true,
    primary_key: "identifier"

  monetize :amount_cents
  monetize :amount_returned_cents, allow_nil: true
  monetize :application_cents, allow_nil: true

  def assign_from_stripe(object)
    assign_attributes(
      amount: Money.new(object.amount, object.currency),
      application: object.application ? Money.new(object.application, object.currency) : nil,
      application_fee: object.application_fee,
      charge_identifier: object.charge,
      created_at: Time.zone.at(object.created),
      currency: object.currency,
      customer_identifier: object.customer,
      email: object.email,
      livemode: object.livemode,
      metadata: JSON.generate(object.metadata),
      selected_shipping_method: object.selected_shipping_method,
      shipping_address_city: object.shipping.address.city,
      shipping_address_country: object.shipping.address.country,
      shipping_address_line1: object.shipping.address.line1,
      shipping_address_line2: object.shipping.address.line2,
      shipping_address_postal_code: object.shipping.address.postal_code,
      shipping_address_state: object.shipping.address.state,
      shipping_carrier: object.shipping.carrier,
      shipping_name: object.shipping.name,
      shipping_phone: object.shipping.phone,
      shipping_tracking_number: object.shipping.tracking_number,
      shipping_methods: object.shipping_methods,
      status: object.status,
      updated_at: Time.zone.at(object.updated)
    )
  end
end
