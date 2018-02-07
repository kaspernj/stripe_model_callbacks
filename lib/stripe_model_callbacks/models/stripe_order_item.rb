class StripeOrderItem < StripeModelCallbacks::ApplicationRecord
  self.primary_key = "id"

  belongs_to :stripe_order, optional: true

  monetize :amount_cents

  def self.stripe_class
    Stripe::OrderItem
  end

  def assign_from_stripe(object)
    assign_attributes(
      amount: Money.new(object.amount, object.currency),
      currency: object.currency,
      description: object.description,
      parent_id: object.parent,
      quantity: object.quantity,
      order_item_type: object.type
    )
  end
end
