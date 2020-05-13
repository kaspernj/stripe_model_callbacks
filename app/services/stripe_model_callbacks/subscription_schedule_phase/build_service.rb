class StripeModelCallbacks::SubscriptionSchedulePhase::BuildService < StripeModelCallbacks::BaseEventService
  def execute
    subscription_schedule_phase = StripeSubscriptionSchedulePhase.find_or_initialize_by(stripe_id: object.id)
    subscription_schedule.assign_from_stripe(object)

    if subscription_schedule_phase.valid?
      succeed!(subscription_schedule_phase: subscription_schedule_phase)
    else
      fail! subscription_schedule_phase.errors.full_messages
    end
  end
end
