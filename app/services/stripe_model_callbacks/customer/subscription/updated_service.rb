class StripeModelCallbacks::Customer::Subscription::UpdatedService < StripeModelCallbacks::BaseEventService
  def execute!
    subscription.assign_from_stripe(object)
    subscription.deleted_at ||= Time.zone.now if event.type == "customer.subscription.deleted"

    if subscription.save
      create_activity
      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: subscription.errors.full_messages)
    end
  end

private

  def create_activity
    case event.type
    when "customer.subscription.trial_will_end"
      subscription.create_activity :trial_will_end
    when "customer.subscription.deleted"
      subscription.create_activity :deleted
    end
  end

  def subscription
    @_subscription ||= StripeSubscription.find_or_initialize_by(id: object.id)
  end
end
