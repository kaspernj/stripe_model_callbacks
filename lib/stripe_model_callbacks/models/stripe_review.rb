class StripeReview < StripeModelCallbacks::ApplicationRecord
  belongs_to :stripe_charge, optional: true, primary_key: "stripe_id"

  def self.stripe_class
    Stripe::Review
  end

  def assign_from_stripe(object)
    assign_attributes(
      stripe_charge_id: object.charge
    )

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self, stripe_model: object,
      attributes: %w[id created livemode open reason]
    )
  end
end
