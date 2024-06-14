class StripeTaxRate < StripeModelCallbacks::ApplicationRecord
  has_many :stripe_subscription_default_tax_rates, dependent: :destroy

  def self.stripe_class
    Stripe::TaxRate
  end

  def create_stripe_mock!
    mock_tax_rate = Stripe::TaxRate.create(id: stripe_id)
    assign_from_stripe(mock_tax_rate)
    save!
  end

  def assign_from_stripe(object)
    check_object_is_stripe_class(object)
    assign_attributes(
      created: Time.zone.at(object.created),
      inclusive: object.inclusive == true,
      stripe_id: object.id
    )

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self,
      stripe_model: object,
      attributes: ["active", "country", "display_name", "description", "jurisdiction", "percentage", "inclusive", "tax_type"]
    )
  end
end
