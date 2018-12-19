class StripeOrderItem < StripeModelCallbacks::ApplicationRecord
  belongs_to :stripe_order, optional: true, primary_key: "stripe_id"

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
