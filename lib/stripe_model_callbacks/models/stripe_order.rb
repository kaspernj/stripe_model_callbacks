class StripeOrder < StripeModelCallbacks::ApplicationRecord
  belongs_to :stripe_charge, optional: true, primary_key: "stripe_id"
  belongs_to :stripe_customer, optional: true, primary_key: "stripe_id"
  has_many :stripe_order_items, primary_key: "stripe_id"

  monetize :amount_cents
  monetize :amount_returned_cents, allow_nil: true
  monetize :application_cents, allow_nil: true

  def self.stripe_class
    Stripe::Order
  end

  def assign_from_stripe(object)
    check_object_is_stripe_class(object)
    assign_attributes(
      stripe_charge_id: object.charge,
      created: Time.zone.at(object.created),
      currency: object.currency,
      stripe_customer_id: object.customer,
      email: object.email,
      livemode: object.livemode,
      metadata: JSON.generate(object.metadata),
      selected_shipping_method: object.selected_shipping_method,
      status: object.status,
      updated: Time.zone.at(object.updated)
    )

    assign_amounts_from_stripe(object)
    assign_shipping_address_from_stripe(object)
    assign_shipping_from_stripe(object)
  end

private

  def assign_amounts_from_stripe(object)
    assign_attributes(
      amount: Money.new(object.amount, object.currency),
      application: object.application ? Money.new(object.application, object.currency) : nil,
      application_fee: object.application_fee
    )
  end

  def assign_shipping_address_from_stripe(object)
    assign_attributes(
      shipping_address_city: object.shipping.address.city,
      shipping_address_country: object.shipping.address.country,
      shipping_address_line1: object.shipping.address.line1,
      shipping_address_line2: object.shipping.address.line2,
      shipping_address_postal_code: object.shipping.address.postal_code,
      shipping_address_state: object.shipping.address.state
    )
  end

  def assign_shipping_from_stripe(object)
    assign_attributes(
      shipping_carrier: object.shipping.carrier,
      shipping_name: object.shipping.name,
      shipping_phone: object.shipping.phone,
      shipping_tracking_number: object.shipping.tracking_number,
      shipping_methods: object.shipping_methods
    )
  end
end
