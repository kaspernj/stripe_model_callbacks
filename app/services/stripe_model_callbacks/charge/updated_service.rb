class StripeModelCallbacks::Charge::UpdatedService < StripeModelCallbacks::BaseEventService
  def perform
    charge.assign_from_stripe(object)

    if charge.save
      create_activity
      succeed!
    else
      fail! charge.errors.full_messages
    end
  end

private

  def charge
    @charge ||= StripeCharge.find_or_initialize_by(stripe_id: object.id)
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
end
