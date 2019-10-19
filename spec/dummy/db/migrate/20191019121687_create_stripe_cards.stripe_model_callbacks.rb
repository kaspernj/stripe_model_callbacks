# This migration comes from stripe_model_callbacks (originally 20180217204628)
class CreateStripeCards < ActiveRecord::Migration[5.1]
  def change
    create_table :stripe_cards do |t|
      t.string :stripe_id, index: true, null: false
      t.string :address_city
      t.string :address_country
      t.string :address_line1
      t.string :address_line1_check
      t.string :address_line2
      t.string :address_state
      t.string :address_zip
      t.string :address_zip_check
      t.string :brand
      t.string :country
      t.string :stripe_customer_id, index: true
      t.string :cvc_check
      t.string :dynamic_last4
      t.integer :exp_month
      t.integer :exp_year
      t.string :fingerprint
      t.string :funding
      t.string :last4
      t.text :metadata
      t.string :name
      t.string :tokenization_method
      t.timestamps
    end
  end
end
