class StripePaymentMethod < StripeModelCallbacks::ApplicationRecord
  def self.stripe_class
    Stripe::PaymentMethod
  end

  def assign_from_stripe(object)
    check_object_is_stripe_class(object)

    self.metadata = object.metadata
    self.stripe_id = object.id
    self.stripe_type = object.type

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self,
      stripe_model: object,
      attributes: %w[
        billing_details card created customer livemode
      ]
    )
  end
end
