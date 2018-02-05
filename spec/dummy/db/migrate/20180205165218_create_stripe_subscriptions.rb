class CreateStripeSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_subscriptions do |t|
      t.string :identifier, index: true, null: false
      t.integer :application_fee_percent
      t.string :billing, null: false
      t.boolean :cancel_at_period_end, null: false
      t.datetime :canceled_at
      t.datetime :current_period_start, null: false
      t.datetime :current_period_end, null: false
      t.string :customer_identifier, index: true, null: false
      t.integer :days_until_due
      t.string :discount, index: true
      t.datetime :ended_at
      t.boolean :livemode, null: false
      t.text :metadata
      t.string :plan_identifier, index: true, null: false
      t.integer :quantity
      t.datetime :start, null: false
      t.integer :tex_percent
      t.datetime :trial_start
      t.datetime :trial_end
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
