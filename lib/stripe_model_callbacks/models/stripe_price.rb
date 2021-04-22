class StripePrice < StripeModelCallbacks::ApplicationRecord
  def self.stripe_class
    Stripe::Price
  end

  def assign_from_stripe(object)
    check_object_is_stripe_class(object)

    assign_attributes(
      stripe_id: object.id,
      stripe_product_id: object.product,
      recurring_aggregate_usage: object.recurring&.aggregate_usage,
      recurring_interval: object.recurring&.interval,
      recurring_interval_count: object.recurring&.interval_count,
      recurring_usage_type: object.recurring&.usage_type,
      transform_quantity_divide_by: object.transform_quantity&.divide_by,
      transform_quantity_round: object.transform_quantity&.round
    )

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self, stripe_model: object,
      attributes: %w[
        active billing_scheme created currency lookup_key metadata nickname tiers_mode unit_amount
      ]
    )
  end
end
