class StripeModelCallbacks::Customer::CreatedService < StripeModelCallbacks::BaseEventService
  def execute!
    customer = StripeModelCallbacks::StripeCustomer.find_or_initialize_by(identifier: object.id)
    customer.assign_from_stripe(object)

    if customer.save
      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: stripe_customer.errors.full_messages)
    end
  end
end
