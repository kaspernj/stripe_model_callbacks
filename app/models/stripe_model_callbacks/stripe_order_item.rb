class StripeModelCallbacks::StripeOrderItem < StripeModelCallbacks::ApplicationRecord
  self.table_name = "stripe_order_items"

  belongs_to :order,
    class_name: "StripeModelCallbacks::StripeOrder",
    foreign_key: "order_identifier",
    inverse_of: :order_items,
    optional: true,
    primary_key: "identifier"

  monetize :amount_cents

  def assign_from_stripe(object)
    assign_attributes(
      amount: Money.new(object.amount, object.currency),
      currency: object.currency,
      description: object.description,
      parent_identifier: object.parent,
      quantity: object.quantity,
      order_item_type: object.type
    )
  end
end
