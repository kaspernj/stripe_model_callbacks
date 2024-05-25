class StripeModelCallbacks::Charge::DisputeUpdatedService < StripeModelCallbacks::BaseEventService
  def perform
    dispute.assign_from_stripe(object)

    if dispute.save
      create_activity
      succeed!
    else
      fail! dispute.errors.full_messages
    end
  end

private

  def dispute
    @dispute ||= StripeDispute.find_or_initialize_by(stripe_id: object.id)
  end

  def create_activity
    case event.type
    when "charge.dispute.closed"
      dispute.try(:create_activity, :closed)
    when "charge.dispute.funds_reinstated"
      dispute.try(:create_activity, :funds_reinstated)
    when "charge.dispute.funds_withdrawn"
      dispute.try(:create_activity, :funds_withdrawn)
    end
  end
end
