# This migration comes from stripe_model_callbacks (originally 20180206115811)
class CreateStripeProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_products do |t|
      t.string :stripe_id, index: true, null: false
      t.boolean :active, default: false, null: false
      t.datetime :deleted_at, index: true
      t.text :stripe_attributes
      t.string :caption
      t.string :description
      t.boolean :livemode, default: true, null: false
      t.text :metadata
      t.string :name
      t.decimal :package_dimensions_height
      t.decimal :package_dimensions_length
      t.decimal :package_dimensions_weight
      t.decimal :package_dimensions_width
      t.boolean :shippable, default: false, null: false
      t.string :statement_descriptor
      t.text :url
      t.datetime :created
      t.datetime :updated
      t.timestamps
    end
  end
end
