class StripeModelCallbacks::Refund::UpdatedService < StripeModelCallbacks::BaseEventService
  def execute!
    refund = StripeModelCallbacks::StripeRefund.find_or_initialize_by(identifier: object.id)
    refund.assign_from_stripe(object)

    if refund.save
      refund.update_columns(created_at: Time.zone.at(object.created))
      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: refund.errors.full_messages)
    end
  end
end
