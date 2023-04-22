class StripeCharge < StripeModelCallbacks::ApplicationRecord
  belongs_to :stripe_customer, optional: true, primary_key: "stripe_id"
  belongs_to :stripe_invoice, optional: true, primary_key: "stripe_id"
  belongs_to :stripe_payment_intent, foreign_key: "payment_intent", optional: true, primary_key: "stripe_id"
  belongs_to :stripe_source, optional: true, primary_key: "stripe_id"
  has_many :stripe_orders, primary_key: "stripe_id"
  has_many :stripe_refunds, primary_key: "stripe_id"
  has_many :stripe_reviews, primary_key: "stripe_id"

  monetize :amount_captured_cents, allow_nil: true
  monetize :amount_cents
  monetize :amount_refunded_cents, allow_nil: true
  monetize :application_cents, allow_nil: true

  def self.stripe_class
    Stripe::Charge
  end

  def assign_from_stripe(object)
    check_object_is_stripe_class(object)
    assign_attributes(
      created: Time.zone.at(object.created),
      stripe_customer_id: object.customer,
      livemode: object.livemode,
      stripe_invoice_id: object.invoice,
      metadata: JSON.generate(object.metadata),
      stripe_id: object.id,
      stripe_order_id: object.try(:order),
      stripe_source_id: object.source
    )

    if object.source.is_a?(String)
      self.stripe_source_id = object.source
    elsif object.source
      self.stripe_source_id = object.source.id
    end

    assign_amounts_from_stripe(object)

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self,
      stripe_model: object,
      attributes: %w[
        captured currency description dispute outcome refunded fraud_details failure_message failure_code on_behalf_of paid
        receipt_email receipt_number review shipping source_transfer statement_descriptor status transfer_group
      ]
    )
  end

  def capture(**opts)
    updated_charge = Stripe::Charge.capture(stripe_id, **opts)
    assign_from_stripe(updated_charge)
    save!
  end

  def refund(**opts)
    StripeRefund.create_on_stripe!(charge: stripe_id, currency: currency)
    updated_charge = Stripe::Charge.retrieve(stripe_id, **opts)
    assign_from_stripe(updated_charge)
    save!
  end

private

  def assign_amounts_from_stripe(object)
    assign_attributes(
      amount: Money.new(object.amount, object.currency),
      amount_captured: object.try(:amount_captured) ? Money.new(object.amount_captured, object.currency) : nil,
      amount_refunded: object.amount_refunded ? Money.new(object.amount_refunded, object.currency) : nil,
      application: object.try(:application) ? Money.new(object.application, object.currency) : nil
    )
  end
end
