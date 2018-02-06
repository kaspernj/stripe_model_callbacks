class StripeProduct < StripeModelCallbacks::ApplicationRecord
  self.primary_key = "id"

  def assign_from_stripe(object)
    assign_attributes(
      active: object.active == true,
      created: Time.zone.at(object.created),
      updated: Time.zone.at(object.updated),
      stripe_attributes: JSON.generate(object.attributes),
      livemode: object.livemode,
      metadata: JSON.generate(object.metadata),
      package_dimensions_height: object.package_dimensions&.height,
      package_dimensions_length: object.package_dimensions&.length,
      package_dimensions_weight: object.package_dimensions&.weight,
      package_dimensions_width: object.package_dimensions&.width,
      shippable: object.shippable == true
    )

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self, stripe_model: object,
      attributes: %w[caption description name statement_descriptor]
    )
  end

  def to_stripe
    @_to_stripe ||= Stripe::Product.retrieve(id)
  end
end
