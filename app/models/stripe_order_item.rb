class StripeOrderItem < StripeModelCallbacks::ApplicationRecord
  belongs_to :order,
    class_name: "StripeOrder",
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
