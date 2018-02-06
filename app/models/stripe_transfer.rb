class StripeTransfer < StripeModelCallbacks::ApplicationRecord
  monetize :amount_cents
  monetize :amount_reversed_cents

  def assign_from_stripe(object)
    assign_attributes(
      amount: Money.new(object.amount, object.currency),
      amount_reversed: Money.new(object.amount_reversed, object.currency),
      created: Time.zone.at(object.created),
      metadata: JSON.generate(object.metadata)
    )

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self, stripe_model: object,
      attributes: %w[
        balance_transaction currency description destination destination_payment livemode reversed
        source_transaction source_type transfer_group status
      ]
    )
  end
end
