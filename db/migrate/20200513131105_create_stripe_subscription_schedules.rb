class CreateStripeSubscriptionSchedules < ActiveRecord::Migration[6.0]
  def change # rubocop:disable Metrics/AbcSize
    create_table :stripe_subscription_schedules do |t|
      t.string :stripe_id, index: {unique: true}, null: false
      t.string :billing
      t.integer :billing_thresholds_amount_gte
      t.boolean :billing_thresholds_reset_billing_cycle_anchor
      t.timestamp :canceled_at
      t.string :collection_method
      t.timestamp :completed_at
      t.datetime :created
      t.datetime :current_phase_start_date
      t.datetime :current_phase_end_date
      t.string :stripe_customer_id, index: true
      t.string :default_payment_method
      t.string :default_source
      t.string :end_behavior
      t.integer :invoice_settings_days_until_due
      t.boolean :livemode
      t.text :metadata
      t.datetime :released_at
      t.string :released_stripe_subscription_id
      t.string :renewal_behavior
      t.string :renewal_interval
      t.string :status
      t.string :stripe_subscription_id, index: true

      t.timestamps
    end
  end
end
