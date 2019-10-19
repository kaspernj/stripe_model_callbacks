# This migration comes from stripe_model_callbacks (originally 20180206115808)
class CreateStripeOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_orders do |table|
      table.string :stripe_id, index: true, null: false
      amount_columns(table)
      table.string :stripe_charge_id, index: true
      table.string :currency, null: false
      table.string :stripe_customer_id, index: true
      table.string :email
      table.boolean :livemode, default: true, null: false
      table.text :metadata
      shipping_columns(table)
      table.string :status, null: false
      table.datetime :created
      table.datetime :updated
      table.timestamps
    end
  end

private

  def amount_columns(table)
    table.integer :amount_cents, null: false
    table.string :amount_currency, null: false
    table.integer :amount_returned_cents
    table.string :amount_returned_currency
    table.integer :application_cents
    table.string :application_currency
    table.integer :application_fee
  end

  def shipping_columns(table)
    table.string :selected_shipping_method
    table.string :shipping_address_city
    table.string :shipping_address_country
    table.string :shipping_address_line1
    table.string :shipping_address_line2
    table.string :shipping_address_postal_code
    table.string :shipping_address_state
    table.string :shipping_carrier
    table.string :shipping_name
    table.string :shipping_phone
    table.string :shipping_tracking_number
    table.string :shipping_methods
  end
end
