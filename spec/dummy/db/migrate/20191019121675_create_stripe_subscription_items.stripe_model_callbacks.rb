# This migration comes from stripe_model_callbacks (originally 20180207121808)
class CreateStripeSubscriptionItems < ActiveRecord::Migration[5.1]
  def change
    create_table :stripe_subscription_items do |t|
      t.string :stripe_id, index: true, null: false
      t.datetime :created
      t.string :stripe_subscription_id, index: true
      t.string :stripe_plan_id, index: true
      t.boolean :deleted, default: false, null: false
      t.text :metadata
      t.decimal :quantity
      t.timestamps
    end
  end
end
