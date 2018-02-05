class StripeModelCallbacks::Charge::RefundedService < StripeModelCallbacks::BaseEventService
  def execute!
    charge = StripeModelCallbacks::StripeCharge.find_or_initialize_by(identifier: object.id)
    charge.assign_from_stripe(object)

    if charge.save
      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: charge.errors.full_messages)
    end
  end
end
