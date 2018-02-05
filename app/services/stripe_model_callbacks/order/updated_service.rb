class StripeModelCallbacks::Order::UpdatedService < StripeModelCallbacks::BaseEventService
  def execute!
    order.assign_from_stripe(object)

    if order.save
      update_created_and_updated_at
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

  def update_created_and_updated_at
    order.update_columns(created_at: Time.zone.at(order.created)) if order.respond_to?(:created)
    order.update_columns(updated_at: Time.zone.at(order.updated)) if order.respond_to?(:updated)
  end
end
