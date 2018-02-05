class StripeModelCallbacks::Order::UpdatedService < StripeModelCallbacks::BaseEventService
  def execute!
    order.assign_from_stripe(object)

    if order.save
      create_order_items

      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: order.errors.full_messages)
    end
  end

private

  def create_order_items
    object.items.each do |order_item|
      stripe_order_item = StripeModelCallbacks::StripeOrderItem.find_or_initialize_by(parent_identifier: order_item.parent)
      stripe_order_item.order_identifier = object.id
      stripe_order_item.assign_from_stripe(order_item)
      stripe_order_item.save!
    end
  end

  def order
    @_order ||= StripeModelCallbacks::StripeOrder.find_or_initialize_by(identifier: object.id)
  end
end
