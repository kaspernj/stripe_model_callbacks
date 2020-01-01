class StripeModelCallbacks::Sku::UpdatedService < StripeModelCallbacks::BaseEventService
  def execute
    sku = StripeSku.find_or_initialize_by(stripe_id: object.id)
    sku.assign_from_stripe(object)
    sku.deleted_at ||= Time.zone.now if event.type == "sku.deleted"

    if sku.save
      sku.create_activity :deleted if event.type == "sku.deleted"
      succeed!
    else
      fail! sku.errors.full_messages
    end
  end
end
