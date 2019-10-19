class StripeModelCallbacks::Coupon::UpdatedService < StripeModelCallbacks::BaseEventService
  def execute
    coupon.assign_from_stripe(object)
    coupon.deleted_at ||= Time.zone.now if event.type == "coupon.deleted"

    if coupon.save
      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: coupon.errors.full_messages)
    end
  end

private

  def coupon
    @coupon ||= StripeCoupon.find_or_initialize_by(stripe_id: object.id)
  end
end
