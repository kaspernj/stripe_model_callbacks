class StripeCallbacks::Customer::Subscription::DeletedService < StripeCallbacks::BaseEventService
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
    @_subscription ||= ::Subscription.find_by!(stripe_subscription_identifier: object.id)
  end
end
