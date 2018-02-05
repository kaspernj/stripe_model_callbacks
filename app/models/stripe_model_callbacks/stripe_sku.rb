class StripeModelCallbacks::StripeSku < StripeModelCallbacks::ApplicationRecord
  self.table_name = "stripe_skus"

  monetize :price_cents

  def assign_from_stripe(object)
    assign_attributes(
      active: object.active == true,
      created_at: Time.zone.at(object.created),
      updated_at: Time.zone.at(object.updated),
      stripe_attributes: JSON.generate(object.attributes),
      inventory_quantity: object.inventory.quantity,
      inventory_type: object.inventory.type,
      inventory_value: object.inventory.value,
      livemode: object.livemode,
      metadata: JSON.generate(object.metadata),
      price: Money.new(object.price, object.currency),
      product_identifier: object.product
    )

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self, stripe_model: object,
      attributes: %w[currency]
    )
  end
end
