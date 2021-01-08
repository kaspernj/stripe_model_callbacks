class ChangeStripeDiscountsCouponRedeemByToTimestamp < ActiveRecord::Migration[6.0]
  def change
    rename_column :stripe_discounts, :coupon_redeem_by, :coupon_redeem_by_int
    add_column :stripe_discounts, :coupon_redeem_by, :datetime
  end
end
