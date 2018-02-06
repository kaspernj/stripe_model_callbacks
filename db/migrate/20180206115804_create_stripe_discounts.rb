class CreateStripeDiscounts < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_discounts do |t|
      t.string :stripe_coupon_id, index: true
      t.string :stripe_customer_id, index: true
      t.string :stripe_subscription_id, index: true
      t.integer :coupon_amount_off_cents
      t.string :coupon_amount_off_currency
      t.string :coupon_currency
      t.datetime :coupon_created
      t.string :coupon_duration
      t.integer :coupon_duration_in_months
      t.boolean :coupon_livemode
      t.integer :coupon_max_redemptions
      t.text :coupon_metadata
      t.integer :coupon_percent_off
      t.integer :coupon_redeem_by
      t.integer :coupon_times_redeemed
      t.boolean :coupon_valid
      t.datetime :created
      t.datetime :deleted_at
      t.datetime :start
      t.datetime :end
      t.timestamps
    end
  end
end
