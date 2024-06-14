class StripeCoupon < StripeModelCallbacks::ApplicationRecord
  has_many :stripe_discounts, primary_key: "stripe_id"

  monetize :amount_off_cents, allow_nil: true

  def self.stripe_class
    Stripe::Coupon
  end

  def assign_from_stripe(object)
    check_object_is_stripe_class(object)
    assign_attributes(
      amount_off: object.amount_off ? Money.new(object.amount_off, object.currency) : nil,
      stripe_valid: object.valid
    )

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self, stripe_model: object,
      attributes: %w[
        currency created duration duration_in_months id livemode max_redemptions metadata
        percent_off redeem_by times_redeemed
      ]
    )
  end

  def create_stripe_mock!
    mock_coupon = Stripe::Coupon.create(
      duration: duration,
      duration_in_months: duration_in_months,
      id: stripe_id,
      percent_off: percent_off
    )
    assign_from_stripe(mock_coupon)
    save!
  end
end
