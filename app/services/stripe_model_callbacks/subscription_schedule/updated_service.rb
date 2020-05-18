class StripeModelCallbacks::SubscriptionSchedule::UpdatedService < StripeModelCallbacks::BaseEventService
  TRACKED_ACTIVITIES = {
    "subscription_schedule.canceled": :canceled
  }.freeze.with_indifferent_access
  private_constant :TRACKED_ACTIVITIES

  def execute
    subscription_schedule.assign_from_stripe(object)
    set_cancellation_date if canceled?

    return success_actions if subscription_schedule.save

    fail!(invoice.subscription_schedule.full_messages)
  end

private

  def canceled?
    @canceled ||= event.type == "subscription_schedule.canceled"
  end

  def create_activity
    return unless tracked_activities[event.type]

    subscription_schedule.create_activity(tracked_activities[event.type])
  end

  def set_cancellation_date
    return unless canceled?

    subscription_schedule.canceled_at ||= Time.zone.now
  end

  def subscription_schedule
    @subscription_schedule ||= StripeSubscriptionSchedule.find_or_initialize_by(stripe_id: object.id)
  end

  def success_actions
    create_activity
    succeed!
  end

  def tracked_activities
    TRACKED_ACTIVITIES
  end
end
