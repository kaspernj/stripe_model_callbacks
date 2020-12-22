class StripeCoupon < StripeModelCallbacks::ApplicationRecord
  has_many :stripe_discounts, primary_key: "stripe_id"

  validates :stripe_id, presence: true

  monetize :amount_off_cents, allow_nil: true

  def self.stripe_class
    Stripe::Coupon
  end

  def assign_from_stripe(object)
    assign_attributes(
      amount_off: object.amount_off ? Money.new(object.amount_off, object.currency) : nil,
      redeem_by: object.redeem_by ? Time.zone.at(object.redeem_by) : nil,
      stripe_valid: object.valid
    )

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self, stripe_model: object,
      attributes: %w[
        currency created duration duration_in_months id livemode max_redemptions metadata
        percent_off times_redeemed
      ]
    )
  end
end
