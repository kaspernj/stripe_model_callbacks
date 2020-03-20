class StripeProduct < StripeModelCallbacks::ApplicationRecord
  has_many :stripe_plans, primary_key: "stripe_id"

  def self.stripe_class
    Stripe::Subscription
  end

  def assign_from_stripe(object)
    assign_attributes(
      active: object.active == true,
      product_type: object.type,
      stripe_attributes: JSON.generate(object.attributes),
      updated: Time.zone.at(object.updated)
    )

    if object.respond_to?(:package_dimensions)
      assign_attributes(
        package_dimensions_height: object.package_dimensions&.height,
        package_dimensions_length: object.package_dimensions&.length,
        package_dimensions_weight: object.package_dimensions&.weight,
        package_dimensions_width: object.package_dimensions&.width
      )
    end

    assign_attributes(shippable: object.shippable == true) if object.respond_to?(:shippable)

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self, stripe_model: object,
      attributes: %w[
        caption created description id livemode name metadata statement_descriptor
      ]
    )
  end
end
