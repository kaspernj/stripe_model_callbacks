class StripeModelCallbacks::Payout::UpdatedService < StripeModelCallbacks::BaseEventService
  def execute
    payout.assign_from_stripe(object)

    if payout.save
      create_activity
      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: payout.errors.full_messages)
    end
  end

private

  def create_activity
    case event.type
    when "payout.canceled"
      payout.create_activity :canceled
    when "payout.failed"
      payout.create_activity :failed
    when "payout.paid"
      payout.create_activity :paid
    end
  end

  def payout
    @_payout ||= StripePayout.find_or_initialize_by(stripe_id: object.id)
  end
end
