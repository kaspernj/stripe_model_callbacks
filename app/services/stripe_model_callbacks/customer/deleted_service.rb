class StripeModelCallbacks::Customer::DeletedService < StripeModelCallbacks::BaseEventService
  def perform
    customer = StripeCustomer.find_or_initialize_by(stripe_id: object.id)
    customer.assign_from_stripe(object)
    customer.deleted_at = Time.zone.now

    if customer.save
      succeed!
    else
      fail! stripe_customer.errors.full_messages
    end
  end
end
