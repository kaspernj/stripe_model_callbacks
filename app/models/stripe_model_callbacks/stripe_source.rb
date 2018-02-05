class StripeModelCallbacks::StripeSource < StripeModelCallbacks::ApplicationRecord
  self.table_name = "stripe_sources"

  monetize :amount_cents, allow_nil: true

  def assign_from_stripe(object)
    assign_attributes(
      amount: object.amount ? Money.new(object.amount, object.currency) : nil,
      client_secret: object.client_secret,
      created_at: Time.zone.at(object.created),
      currency: object.currency,
      flow: object.flow,
      livemode: object.livemode,
      metadata: JSON.generate(object.metadata)
    )
  end
end
