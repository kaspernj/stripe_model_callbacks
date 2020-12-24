class StripeModelCallbacks::Price::UpdatedService < StripeModelCallbacks::BaseEventService
  def execute
    price = StripePrice.find_or_initialize_by(stripe_id: object.id)
    price.assign_from_stripe(object)
    price.deleted_at ||= Time.zone.now if event.type == "price.deleted"

    if price.save
      price.create_activity :deleted if event.type == "price.deleted"
      succeed!
    else
      fail! price.errors.full_messages
    end
  end
end
