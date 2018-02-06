class StripeModelCallbacks::Charge::DisputeUpdatedService < StripeModelCallbacks::BaseEventService
  def execute!
    dispute.assign_from_stripe(object)

    if dispute.save
      create_activity
      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: dispute.errors.full_messages)
    end
  end

private

  def dispute
    @_dispute ||= StripeDispute.find_or_initialize_by(identifier: object.id)
  end

  def create_activity
    case event.type
    when "charge.dispute.closed"
      dispute.create_activity :closed
    when "charge.dispute.funds_reinstated"
      dispute.create_activity :funds_reinstated
    when "charge.dispute.funds_withdrawn"
      dispute.create_activity :funds_withdrawn
    end
  end
end
