class StripeModelCallbacks::Customer::DiscountUpdatedService < StripeModelCallbacks::BaseEventService
  def execute!
    discount.assign_from_stripe(object)
    discount.deleted_at ||= Time.zone.now if event.type == "customer.discount.deleted"

    if discount.save
      create_activity
      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: discount.errors.full_messages)
    end
  end

private

  def create_activity
    discount.create_activity :deleted if event.type == "customer.discount.deleted"
  end

  def coupon_id_look_up_by
    event.data.try(:previous_attributes).try(:coupon).try(:id) ||
      object.coupon.id
  end

  def discount
    @_discount ||= StripeDiscount.find_or_initialize_by(
      stripe_coupon_id: coupon_id_look_up_by,
      stripe_customer_id: object.customer,
      stripe_subscription_id: object.subscription&.id
    )
  end
end
