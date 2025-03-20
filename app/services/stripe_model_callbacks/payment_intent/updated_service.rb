class StripeModelCallbacks::PaymentIntent::UpdatedService < StripeModelCallbacks::BaseEventService
  def perform
    payment_intent = StripePaymentIntent.find_or_initialize_by(stripe_id: object.id)
    payment_intent.assign_from_stripe(object)

    if payment_intent.save
      create_activity!(payment_intent) if event
      succeed!
    else
      fail! payment_intent.errors.full_messages
    end
  end

  def create_activity!(payment_intent)
    match = event.type.match(/\Apayment_intent\.(.+)$/)
    activity_type = match[1].to_sym
    payment_intent.create_audit!(action: activity_type)
  end
end
