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
      amount: Money.new(object.amount, object.currency),
      amount_refunded: object.amount_refunded ? Money.new(object.amount_refunded, object.currency) : nil,
      application: object.application ? Money.new(object.application, object.currency) : nil,
      captured: object.captured,
      created_at: Time.zone.at(object.created),
      currency: object.currency,
      customer_identifier: object.customer,
      description: object.description,
      dispute: object.dispute,
      livemode: object.livemode,
      failure_code: object.failure_code,
      failure_message: object.failure_message,
      fraud_details: object.fraud_details,
      invoice_identifier: object.invoice,
      metadata: JSON.generate(object.metadata),
      on_behalf_of: object.on_behalf_of,
      order_identifier: object.order,
      outcome: object.outcome,
      paid: object.paid,
      receipt_email: object.receipt_email,
      receipt_number: object.receipt_number,
      refunded: object.refunded,
      review: object.review,
      shipping: object.shipping,
      source_identifier: object.source,
      source_transfer: object.source_transfer,
      statement_descriptor: object.statement_descriptor,
      status: object.status,
      transfer_group: object.transfer_group
    )
  end
end
