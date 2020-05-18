class StripeModelCallbacks::SubscriptionSchedule::UpdatedService < StripeModelCallbacks::BaseEventService
  def execute
    subscription_schedule.assign_from_stripe(object)
    subscription_schedule.canceled_at ||= Time.zone.now if canceled?

    if subscription_schedule.save
      subscription_schedule.create_activity :canceled if canceled?
      succeed!
    else
      fail! subscription_schedule.errors.full_messages
    end
  end

  def canceled?
    @canceled ||= event.type == "subscription_schedule.canceled"
  end

  def subscription_schedule
    @subscription_schedule ||= StripeSubscriptionSchedule.find_or_initialize_by(stripe_id: object.id)
  end
end
