class StripeModelCallbacks::Customer::Subscription::UpdatedService < StripeModelCallbacks::BaseEventService
  def execute!
    subscription.assign_from_stripe(object)

    if subscription.save
      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: subscription.errors.full_messages)
    end
  end

private

  def subscription
    @_subscription ||= StripeModelCallbacks::StripeSubscription.find_by!(identifier: object.id)
  end
end
