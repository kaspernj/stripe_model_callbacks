class StripeModelCallbacks::Customer::DeletedService < StripeModelCallbacks::BaseEventService
  def execute!
    customer = StripeCustomer.find_or_initialize_by(stripe_id: object.id)
    customer.assign_from_stripe(object)
    customer.deleted_at = Time.zone.now

    if customer.save
      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: stripe_customer.errors.full_messages)
    end
  end
end
