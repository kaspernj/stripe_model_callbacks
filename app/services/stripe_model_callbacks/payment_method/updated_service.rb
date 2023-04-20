class StripeModelCallbacks::PaymentMethod::UpdatedService < StripeModelCallbacks::BaseEventService
  def perform
    payment_method = StripePaymentMethod.find_or_initialize_by(stripe_id: object.id)
    payment_method.assign_from_stripe(object)

    if payment_method.save
      create_activity!(payment_method)
      succeed!
    else
      fail! payment_method.errors.full_messages
    end
  end

  def create_activity!(payment_method)
    match = event.type.match(/\Apayment_method\.(.+)$/)
    activity_type = match[1].to_sym
    payment_method.create_activity activity_type
  end
end
