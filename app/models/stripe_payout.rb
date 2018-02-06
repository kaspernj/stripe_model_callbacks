class StripePayout < StripeModelCallbacks::ApplicationRecord
  self.primary_key = "id"

  monetize :amount_cents, allow_nil: true

  def assign_from_stripe(object)
    assign_attributes(
      amount: Money.new(object.amount, object.currency),
      arrival_date: Time.zone.at(object.arrival_date),
      created: Time.zone.at(object.created),
      metadata: JSON.generate(object.metadata),
      stripe_method: object.method,
      stripe_type: object.type
    )

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self, stripe_model: object,
      attributes: %w[
        automatic balance_transaction currency description destination failure_balance_transaction
        failure_code failure_message livemode source_type statement_descriptor status
      ]
    )
  end

  def to_stripe
    @_to_stripe ||= Stripe::Payout.retrieve(id)
  end
end
