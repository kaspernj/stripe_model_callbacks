class StripeBankAccount < StripeModelCallbacks::ApplicationRecord
  self.primary_key = "id"

  def self.stripe_class
    Stripe::BankAccount
  end

  def assign_from_stripe(object)
    assign_attributes(stripe_account_id: object.account)

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self, stripe_model: object,
      attributes: %w[
        id account_holder_name account_holder_type bank_name country currency default_for_currency
        fingerprint last4 metadata routing_number status
      ]
    )
  end
end
