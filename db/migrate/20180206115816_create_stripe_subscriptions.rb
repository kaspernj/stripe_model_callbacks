class CreateStripeSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_subscriptions, id: false do |t|
      t.string :id, primary: true, null: false
      t.integer :application_fee_percent
      t.string :billing, null: false
      t.boolean :cancel_at_period_end, null: false
      t.datetime :canceled_at
      t.datetime :current_period_start, null: false
      t.datetime :current_period_end, null: false
      t.string :stripe_customer_id, index: true, null: false
      t.integer :days_until_due
      t.string :discount, index: true
      t.datetime :ended_at
      t.boolean :livemode, default: true, null: false
      t.text :metadata
      t.string :stripe_plan_id, index: true, null: false
      t.integer :quantity
      t.datetime :start, null: false
      t.integer :tax_percent
      t.string :status, index: true
      t.datetime :trial_start
      t.datetime :trial_end
      t.datetime :deleted_at, index: true
      t.datetime :created
      t.timestamps
    end
  end
end
