class StripeRecipient < StripeModelCallbacks::ApplicationRecord
  def self.stripe_class
    Stripe::Recipient
  end

  def assign_from_stripe(object)
    assign_attributes(
      stripe_type: object.type
    )

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self, stripe_model: object,
      attributes: %w[active_account description email name migrated_to verified]
    )
  end
end
