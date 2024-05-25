class StripeModelCallbacks::Customer::Subscription::UpdatedService < StripeModelCallbacks::BaseEventService
  def perform
    subscription.assign_from_stripe(object)
    subscription.deleted_at ||= Time.zone.now if event.type == "customer.subscription.deleted"

    if subscription.save
      create_activity
      succeed!
    else
      fail! subscription.errors.full_messages
    end
  end

private

  def create_activity
    case event.type
    when "customer.subscription.trial_will_end"
      subscription.try(:create_activity, :trial_will_end)
    when "customer.subscription.deleted"
      subscription.try(:create_activity, :deleted)
    end
  end

  def subscription
    @subscription ||= StripeSubscription.find_or_initialize_by(stripe_id: object.id)
  end
end
