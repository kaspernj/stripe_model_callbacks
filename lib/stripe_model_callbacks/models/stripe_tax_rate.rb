class StripeTaxRate < StripeModelCallbacks::ApplicationRecord
  def self.stripe_class
    Stripe::TaxRate
  end

  def assign_from_stripe(object)
    assign_attributes(
      created: Time.zone.at(object.created),
      inclusive: object.inclusive == true
    )

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self,
      stripe_model: object,
      attributes: %w[display_name description jurisdiction percentage inclusive]
    )
  end
end
