class StripeCallbacks::Customer::Subscription::CreatedService < StripeCallbacks::BaseEventService
  def execute!
    subscription = ::Subscription.new( state: "active")
    subscription.assign_from_stripe(object)

    if subscription.save
      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: subscription.errors.full_messages)
    end
  end
end
