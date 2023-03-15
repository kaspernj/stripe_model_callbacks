class StripeModelCallbacks::Customer::UpdatedService < StripeModelCallbacks::BaseEventService
  def perform
    customer = StripeCustomer.find_or_initialize_by(stripe_id: object.id)
    customer.assign_from_stripe(object)
    customer.deleted_at ||= Time.zone.now if event.type == "customer.deleted"

    if customer.save
      succeed! customer
    else
      fail! customer.errors.full_messages
    end
  end
end
