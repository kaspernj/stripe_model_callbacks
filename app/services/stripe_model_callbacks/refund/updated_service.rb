class StripeModelCallbacks::Refund::UpdatedService < StripeModelCallbacks::BaseEventService
  def execute
    refund = StripeRefund.find_or_initialize_by(stripe_id: object.id)
    refund.assign_from_stripe(object)

    if refund.save
      succeed!
    else
      fail! refund.errors.full_messages
    end
  end
end
