class StripeModelCallbacks::Order::UpdatedService < StripeModelCallbacks::BaseEventService
  def perform
    order.assign_from_stripe(object)

    if order.save
      create_order_items

      succeed!
    else
      fail! order.errors.full_messages
    end
  end

private

  def create_order_items
    object.items.each do |order_item|
      stripe_order_item = StripeOrderItem.find_or_initialize_by(parent_id: order_item.parent)
      stripe_order_item.stripe_order_id = object.id
      stripe_order_item.assign_from_stripe(order_item)
      stripe_order_item.save!
    end
  end

  def order
    @order ||= StripeOrder.find_or_initialize_by(stripe_id: object.id)
  end
end
