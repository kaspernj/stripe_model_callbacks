class StripeRefund < StripeModelCallbacks::ApplicationRecord
  belongs_to :stripe_charge, optional: true, primary_key: "stripe_id"

  monetize :amount_cents, allow_nil: true

  def self.stripe_class
    Stripe::Refund
  end

  def assign_from_stripe(object)
    assign_attributes(
      amount: Money.new(object.amount, object.currency),
      stripe_charge_id: object.charge,
      created: Time.zone.at(object.created),
      livemode: object.try(:livemode) == true,
      metadata: JSON.generate(object.metadata)
    )

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self,
      stripe_model: object,
      attributes: %w[balance_transaction currency reason receipt_number status]
    )

    self.failure_reason = object.failure_reason if object.respond_to?(:failure_reason)
    self.failure_balance_transaction = object.failure_balance_transaction if object.respond_to?(:failure_balance_transaction)
  end
end
