# This migration comes from stripe_model_callbacks (originally 20200513131120)
class CreateStripeSubscriptionSchedulePhases < ActiveRecord::Migration[6.0]
  def change
    create_table :stripe_subscription_schedule_phases do |t|
      t.string :stripe_subscription_schedule_id, index: {name: "index_subscription_schedule_phases_on_subscription_schedule_id"}, null: false
      t.integer :application_fee_percent
      t.integer :billing_thresholds_amount_gte
      t.boolean :billing_thresholds_reset_billing_cycle_anchor
      t.string :collection_method
      t.string :stripe_coupon_id, index: true
      t.string :default_payment_method
      t.datetime :end_date
      t.integer :invoice_settings_days_until_due
      t.boolean :prorate
      t.string :proration_behavior
      t.datetime :start_date
      t.datetime :trial_end

      t.timestamps
    end
  end
end
