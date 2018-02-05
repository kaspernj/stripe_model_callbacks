class CreateStripeOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_orders do |t|
      t.string :identifier, index: true, null: false
      t.integer :amount_cents, null: false
      t.string :amount_currency, null: false
      t.integer :amount_returned_cents
      t.string :amount_returned_currency
      t.integer :application_cents
      t.string :application_currency
      t.integer :application_fee
      t.string :charge_identifier, index: true
      t.string :currency, null: false
      t.string :customer_identifier, index: true
      t.string :email
      t.boolean :livemode, null: false
      t.text :metadata
      t.string :selected_shipping_method
      t.string :shipping_address_city
      t.string :shipping_address_country
      t.string :shipping_address_line1
      t.string :shipping_address_line2
      t.string :shipping_address_postal_code
      t.string :shipping_address_state
      t.string :shipping_carrier
      t.string :shipping_name
      t.string :shipping_phone
      t.string :shipping_tracking_number
      t.string :shipping_methods
      t.string :status, null: false
      t.timestamps
    end
  end
end
