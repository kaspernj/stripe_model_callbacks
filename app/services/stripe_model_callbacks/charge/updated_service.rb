class StripeModelCallbacks::Charge::UpdatedService < StripeModelCallbacks::BaseEventService
  def execute!
    charge.assign_from_stripe(object)

    if charge.save
      create_refunds if event.type == "charge.refunded"
      create_activity
      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: charge.errors.full_messages)
    end
  end

private

  def charge
    @_charge ||= StripeModelCallbacks::StripeCharge.find_or_initialize_by(identifier: object.id)
  end

  def create_activity
    case event.type
    when "charge.captured"
      charge.create_activity :captured
    when "charge.failed"
      charge.create_activity :failed
    when "charge.pending"
      charge.create_activity :pending
    when "charge.refunded"
      charge.create_activity :refunded
    when "charge.succeeded"
      charge.create_activity :succeeded
    end
  end

  def create_refunds
    object.refunds.each do |stripe_refund|
      StripeModelCallbacks::Refund::UpdatedService.reported_execute!(object: stripe_refund)
    end
  end
end
