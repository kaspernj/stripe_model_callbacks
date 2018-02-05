class StripeModelCallbacks::Refund::UpdatedService < StripeModelCallbacks::BaseEventService
  def execute!
    refund = StripeModelCallbacks::StripeRefund.find_or_initialize_by(identifier: object.id)
    refund.assign_from_stripe(object)

    if refund.save
      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: refund.errors.full_messages)
    end
  end
end