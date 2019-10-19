# This migration comes from stripe_model_callbacks (originally 20180206115815)
class CreateStripeSources < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_sources do |table|
      table.string :stripe_id, index: true, null: false
      table.integer :amount_cents
      table.string :amount_currency
      table.string :client_secret, null: false
      table.string :currency
      table.string :flow, null: false
      table.boolean :livemode, default: true, null: false
      table.string :metadata
      create_owner_columns(table)
      create_receiver_columns(table)
      table.string :redirect_failure_reason
      table.string :redirect_return_url
      table.string :redirect_status
      table.text :redirect_url
      table.string :statement_descriptor
      table.string :status
      table.string :stripe_type
      table.string :usage
      create_ach_columns(table)
      table.datetime :created
      table.timestamps
    end
  end

private

  def create_owner_columns(table)
    table.string :owner_address_city
    table.string :owner_address_country
    table.string :owner_address_line1
    table.string :owner_address_line2
    table.string :owner_address_postal_code
    table.string :owner_address_state
    table.string :owner_email
    table.string :owner_name
    table.string :owner_phone
    table.string :owner_verified_address_city
    table.string :owner_verified_address_country
    table.string :owner_verified_address_line1
    table.string :owner_verified_address_line2
    table.string :owner_verified_address_postal_code
    table.string :owner_verified_address_state
    table.string :owner_verified_email
    table.string :owner_verified_name
    table.string :owner_verified_phone
  end

  def create_receiver_columns(table)
    table.string :receiver_address
    table.integer :receiver_amount_charged_cents
    table.string :receiver_amount_charged_currency
    table.integer :receiver_amount_received_cents
    table.string :receiver_amount_received_currency
    table.integer :receiver_amount_returned_cents
    table.string :receiver_amount_returned_currency
    table.string :receiver_refund_attributes_method
    table.string :receiver_refund_attributes_status
  end

  def create_ach_columns(table)
    table.string :ach_credit_transfer_account_number
    table.string :ach_credit_transfer_routing_number
    table.string :ach_credit_transfer_fingerprint
    table.string :ach_credit_transfer_bank_name
    table.string :ach_credit_transfer_swift_code
  end
end
