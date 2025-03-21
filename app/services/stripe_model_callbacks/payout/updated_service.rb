class StripeModelCallbacks::Payout::UpdatedService < StripeModelCallbacks::BaseEventService
  def perform
    payout.assign_from_stripe(object)

    if payout.save
      create_activity
      succeed!
    else
      fail! payout.errors.full_messages
    end
  end

private

  def create_activity
    case event.type
    when "payout.canceled"
      payout.create_audit!(action: :canceled)
    when "payout.failed"
      payout.create_audit!(action: :failed)
    when "payout.paid"
      payout.create_audit!(action: :paid)
    end
  end

  def payout
    @payout ||= StripePayout.find_or_initialize_by(stripe_id: object.id)
  end
end
