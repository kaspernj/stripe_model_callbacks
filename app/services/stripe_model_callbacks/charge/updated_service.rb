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
      charge.create_audit!(action: :captured)
    when "charge.failed"
      charge.create_audit!(action: :failed)
    when "charge.pending"
      charge.create_audit!(action: :pending)
    when "charge.refunded"
      charge.create_audit!(action: :refunded)
    when "charge.succeeded"
      charge.create_audit!(action: :succeeded)
    end
  end
end
