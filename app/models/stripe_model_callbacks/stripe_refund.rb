class StripeModelCallbacks::StripeRefund < StripeModelCallbacks::ApplicationRecord
  self.table_name = "stripe_refunds"

  belongs_to :charge,
    class_name: "StripeModelCallbacks::StripeCharge",
    foreign_key: "charge_identifier",
    optional: true,
    primary_key: "identifier"

  monetize :amount_cents, allow_nil: true

  def assign_from_stripe(object)
    assign_attributes(
      amount: Money.new(object.amount, object.currency),
      balance_transaction: object.balance_transaction,
      charge_identifier: object.charge,
      currency: object.currency,
      livemode: object.try(:livemode) == true,
      metadata: JSON.generate(object.metadata),
      reason: object.reason,
      receipt_number: object.receipt_number,
      status: object.status
    )

    self.failure_reason = object.failure_reason if object.respond_to?(:failure_reason)
    self.failure_balance_transaction = object.failure_balance_transaction if object.respond_to?(:failure_balance_transaction)
  end
end
