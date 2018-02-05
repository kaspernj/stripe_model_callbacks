class StripeModelCallbacks::StripeCharge < StripeModelCallbacks::ApplicationRecord
  self.table_name = "stripe_charges"

  belongs_to :customer,
    class_name: "StripeModelCallbacks::StripeCustomer",
    foreign_key: "customer_identifier",
    optional: true,
    primary_key: "identifier"

  monetize :amount_cents
  monetize :amount_refunded_cents, allow_nil: true
  monetize :application_cents, allow_nil: true

  def assign_from_stripe(object)
    assign_attributes(
      created_at: Time.zone.at(object.created),
      customer_identifier: object.customer,
      livemode: object.livemode,
      invoice_identifier: object.invoice,
      metadata: JSON.generate(object.metadata),
      order_identifier: object.order,
      source_identifier: object.source
    )

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

private

  def assign_amounts_from_stripe(object)
    assign_attributes(
      amount: Money.new(object.amount, object.currency),
      amount_refunded: object.amount_refunded ? Money.new(object.amount_refunded, object.currency) : nil,
      application: object.application ? Money.new(object.application, object.currency) : nil
    )
  end
end
