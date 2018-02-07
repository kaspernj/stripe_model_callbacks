class StripeSku < StripeModelCallbacks::ApplicationRecord
  self.primary_key = "id"

  monetize :price_cents

  def self.stripe_class
    Stripe::Sku
  end

  def assign_from_stripe(object)
    assign_attributes(
      active: object.active == true,
      created: Time.zone.at(object.created),
      updated: Time.zone.at(object.updated),
      stripe_attributes: JSON.generate(object.attributes),
      inventory_quantity: object.inventory.quantity,
      inventory_type: object.inventory.type,
      inventory_value: object.inventory.value,
      livemode: object.livemode,
      metadata: JSON.generate(object.metadata),
      price: Money.new(object.price, object.currency),
      stripe_product_id: object.product
    )

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self, stripe_model: object,
      attributes: %w[currency]
    )
  end
end
