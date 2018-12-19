class CreateStripeSkus < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_skus do |t|
      t.string :stripe_id, index: true, null: false
      t.boolean :active, default: false, null: false
      t.datetime :deleted_at, index: true
      t.text :stripe_attributes
      t.string :currency, null: false
      t.integer :inventory_quantity
      t.string :inventory_type
      t.string :inventory_value
      t.boolean :livemode
      t.text :metadata
      t.integer :price_cents
      t.string :price_currency
      t.string :stripe_product_id, index: true
      t.datetime :created
      t.datetime :updated
      t.timestamps
    end
  end
end
