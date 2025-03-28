class StripeModelCallbacks::Customer::SourceUpdatedService < StripeModelCallbacks::BaseEventService
  def perform
    source = stripe_class.find_or_initialize_by(stripe_id: object.id)
    source.assign_from_stripe(object)
    source.deleted_at = Time.zone.now if event&.type == "customer.source.deleted"

    if source.save
      source.create_audit!(action: :deleted) if event&.type == "customer.source.deleted"
      source.create_audit!(action: :expiring) if event&.type == "customer.source.expiring"
      succeed!
    else
      fail! source.errors.full_messages
    end
  end

private

  def stripe_class
    if object.object == "card"
      StripeCard
    else
      StripeSource
    end
  end
end
