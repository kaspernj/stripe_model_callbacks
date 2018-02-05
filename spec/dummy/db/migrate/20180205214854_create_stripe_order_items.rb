class CreateStripeOrderItems < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_order_items do |t|
      t.string :parent_identifier, index: true, null: false
      t.string :order_identifier, index: true, null: false
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
