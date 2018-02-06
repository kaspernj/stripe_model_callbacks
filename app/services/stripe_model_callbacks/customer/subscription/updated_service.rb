class StripeModelCallbacks::Customer::Subscription::UpdatedService < StripeModelCallbacks::BaseEventService
  def execute!
    subscription ||= StripeSubscription.find_or_initialize_by(identifier: object.id)
    subscription.assign_from_stripe(object)
    subscription.deleted_at ||= Time.zone.now if event.type == "customer.subscription.deleted"

    if subscription.save
      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: subscription.errors.full_messages)
    end
  end
end
