class StripeModelCallbacks::SubscriptionSchedule::UpdatedService < StripeModelCallbacks::BaseEventService
  def execute
    subscription_schedule.assign_from_stripe(object)
    subscription_schedule.canceled_at ||= Time.zone.now if cancel?
    subscription_schedule.subscription_schedule_phases = new_subscription_schedule_phases

    if subscription_schedule.save
      subscription_schedule.create_activity :canceled if cancel?
      succeed!
    else
      fail! subscription_schedule.errors.full_messages
    end
  end

  def cancel?
    @cancel ||= event.type == "subscription_schedule.canceled"
  end

  def subscription_schedule
    @subscription_schedule ||= StripeSubscriptionSchedule.find_or_initialize_by(stripe_id: object.id)
  end

  def new_subscription_schedule_phases
    @new_subscription_schedule_phases ||= object.phases.collect do |phase_data|
      phase_data = phase_data.merge(stripe_subscription_schedule_id: subscription_schedule.id)
      StripeModelCallbacks::SubscriptionSchedulePhase::BuildService(phase_data).result.fetch(:subscription_schedule_phase)
    end
  end
end
