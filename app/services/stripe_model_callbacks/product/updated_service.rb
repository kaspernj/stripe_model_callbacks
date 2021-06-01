class StripeModelCallbacks::Product::UpdatedService < StripeModelCallbacks::BaseEventService
  def perform
    product = StripeProduct.find_or_initialize_by(stripe_id: object.id)
    product.assign_from_stripe(object)
    product.deleted_at ||= Time.zone.now if event.type == "product.deleted"

    if product.save
      product.create_activity :deleted if event.type == "product.deleted"
      succeed!
    else
      fail! product.errors.full_messages
    end
  end
end
