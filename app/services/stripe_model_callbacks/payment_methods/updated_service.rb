class StripeModelCallbacks::PaymentMethods::UpdatedService < StripeModelCallbacks::BaseEventService
  def perform
    product = StripePaymentMethod.find_or_initialize_by(stripe_id: object.id)
    product.assign_from_stripe(object)

    if product.save
      product.create_activity :attached if event.type == "payment_method.attached"
      product.create_activity :automatically_updated if event.type == "payment_method.automatically_updated"
      product.create_activity :card_automatically_updated if event.type == "payment_method.card_automatically_updated"
      product.create_activity :detached if event.type == "payment_method.detached"
      product.create_activity :updated if event.type == "payment_method.updated"
      succeed!
    else
      fail! product.errors.full_messages
    end
  end
end
