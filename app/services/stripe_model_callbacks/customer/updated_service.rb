class StripeModelCallbacks::Customer::UpdatedService < StripeModelCallbacks::BaseEventService
  def execute!
    stripe_customer.assign_from_stripe(object)

    if stripe_customer.save
      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: stripe_customer.errors.full_messages)
    end
  end

private

  def stripe_customer
    @_stripe_customer ||= StripeModelCallbacks::StripeCustomer.find_by!(identifier: object.id)
  end
end
