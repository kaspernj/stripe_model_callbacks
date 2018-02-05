class StripeModelCallbacks::StripeRecipient < StripeModelCallbacks::ApplicationRecord
  self.table_name = "stripe_recipients"

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
