class StripeProduct < StripeModelCallbacks::ApplicationRecord
  self.primary_key = "id"

  has_many :stripe_plans

  def self.stripe_class
    Stripe::Subscription
  end

  def assign_from_stripe(object)
    assign_attributes(
      active: object.active == true,
      updated: Time.zone.at(object.updated),
      stripe_attributes: JSON.generate(object.attributes),
      package_dimensions_height: object.package_dimensions&.height,
      package_dimensions_length: object.package_dimensions&.length,
      package_dimensions_weight: object.package_dimensions&.weight,
      package_dimensions_width: object.package_dimensions&.width,
      shippable: object.shippable == true
    )

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self, stripe_model: object,
      attributes: %w[
        caption created description id livemode name metadata statement_descriptor
      ]
    )
  end
end
