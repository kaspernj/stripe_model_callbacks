# This migration comes from stripe_model_callbacks (originally 20180206115807)
class CreateStripeOrderItems < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_order_items do |t|
      t.string :parent_id, index: true, null: false
      t.string :stripe_order_id, index: true, null: false
      t.integer :amount_cents, null: false
      t.string :amount_currency, null: false
      t.string :currency, null: false
      t.string :description
      t.integer :quantity
      t.string :order_item_type
      t.timestamps
    end
  end
end
