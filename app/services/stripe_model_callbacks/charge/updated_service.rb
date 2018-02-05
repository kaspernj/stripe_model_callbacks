class StripeModelCallbacks::Charge::UpdatedService < StripeModelCallbacks::BaseEventService
  def execute!
    charge = StripeModelCallbacks::StripeCharge.find_or_initialize_by(identifier: object.id)
    charge.assign_from_stripe(object)

    if charge.save
      charge.create_activity :captured if event.type == "charge.captured"
      charge.create_activity :failed if event.type == "charge.failed"
      charge.create_activity :pending if event.type == "charge.pending"
      charge.create_activity :refunded if event.type == "charge.refunded"
      charge.create_activity :succeeded if event.type == "charge.succeeded"

      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: charge.errors.full_messages)
    end
  end
end
