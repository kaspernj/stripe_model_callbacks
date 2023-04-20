class StripeModelCallbacks::PaymentMethod::UpdatedService < StripeModelCallbacks::BaseEventService
  def perform
    payment_method = StripePaymentMethod.find_or_initialize_by(stripe_id: object.id)
    payment_method.assign_from_stripe(object)

    if payment_method.save
      payment_method.create_activity :attached if event.type == "payment_method.attached"
      payment_method.create_activity :automatically_updated if event.type == "payment_method.automatically_updated"
      payment_method.create_activity :card_automatically_updated if event.type == "payment_method.card_automatically_updated"
      payment_method.create_activity :detached if event.type == "payment_method.detached"
      payment_method.create_activity :updated if event.type == "payment_method.updated"
      succeed!
    else
      fail! payment_method.errors.full_messages
    end
  end
end
