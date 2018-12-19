class CreateStripeCoupons < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_coupons do |t|
      t.string :stripe_id, index: true, null: false
      t.integer :amount_off_cents
      t.string :amount_off_currency
      t.datetime :created
      t.datetime :deleted_at, index: true
      t.string :currency
      t.string :duration
      t.integer :duration_in_months
      t.boolean :livemode, default: true, null: false
      t.integer :max_redemptions
      t.text :metadata
      t.integer :percent_off
      t.datetime :redeem_by
      t.integer :times_redeemed
      t.boolean :stripe_valid
      t.timestamps
    end
  end
end
