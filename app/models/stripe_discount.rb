class StripeDiscount < StripeModelCallbacks::ApplicationRecord
  belongs_to :coupon,
    class_name: "StripeCoupon",
    foreign_key: "coupon_identifier",
    inverse_of: :discounts,
    optional: true,
    primary_key: "identifier"

  belongs_to :customer,
    class_name: "StripeCustomer",
    foreign_key: "customer_identifier",
    inverse_of: :discounts,
    optional: true,
    primary_key: "identifier"

  belongs_to :subscription,
    class_name: "StripeSubscription",
    foreign_key: "subscription_identifier",
    inverse_of: :discounts,
    optional: true,
    primary_key: "identifier"

  has_many :subscriptions,
    class_name: "StripeSubscription",
    dependent: :restrict_with_error,
    foreign_key: "discount_identifier",
    inverse_of: :discount,
    primary_key: "identifier"

  monetize :coupon_amount_off_cents, allow_nil: true

  def assign_from_stripe(object)
    assign_attributes(
      created: object.respond_to?(:created) ? Time.zone.at(object.created) : nil,
      start: Time.zone.at(object.start),
      end: Time.zone.at(object.end),
      customer_identifier: object.customer,
      subscription_identifier: object.subscription&.id
    )

    assign_coupon_attributes(object)
    assign_other_coupon_attributes(object)
  end

private

  def assign_coupon_attributes(object)
    assign_attributes(
      coupon_amount_off_cents: object.coupon.amount_off ? Money.new(object.coupon.amount_off, object.coupon.currency) : nil,
      coupon_created: Time.zone.at(object.coupon.created),
      coupon_currency: object.coupon.currency,
      coupon_duration: object.coupon.duration,
      coupon_duration_in_months: object.coupon.duration_in_months,
      coupon_livemode: object.coupon.livemode
    )
  end

  def assign_other_coupon_attributes(object)
    assign_attributes(
      coupon_max_redemptions: object.coupon.max_redemptions,
      coupon_metadata: JSON.generate(object.coupon.metadata),
      coupon_percent_off: object.coupon.percent_off,
      coupon_redeem_by: object.coupon.redeem_by ? Time.zone.at(object.coupon.redeem_by) : nil,
      coupon_times_redeemed: object.coupon.times_redeemed,
      coupon_valid: object.coupon.valid
    )
  end
end
