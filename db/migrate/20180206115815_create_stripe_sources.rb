class CreateStripeSources < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_sources do |t|
      t.string :stripe_id, index: true, null: false
      t.integer :amount_cents
      t.string :amount_currency
      t.string :client_secret, null: false
      t.string :currency
      t.string :flow, null: false
      t.boolean :livemode, default: true, null: false
      t.string :metadata
      create_owner_columns(t)
      create_receiver_columns(t)
      t.string :redirect_failure_reason
      t.string :redirect_return_url
      t.string :redirect_status
      t.text :redirect_url
      t.string :statement_descriptor
      t.string :status
      t.string :stripe_type
      t.string :usage
      create_ach_columns(t)
      t.datetime :created
      t.timestamps
    end
  end

private

  def create_owner_columns(t)
    t.string :owner_address_city
    t.string :owner_address_country
    t.string :owner_address_line1
    t.string :owner_address_line2
    t.string :owner_address_postal_code
    t.string :owner_address_state
    t.string :owner_email
    t.string :owner_name
    t.string :owner_phone
    t.string :owner_verified_address_city
    t.string :owner_verified_address_country
    t.string :owner_verified_address_line1
    t.string :owner_verified_address_line2
    t.string :owner_verified_address_postal_code
    t.string :owner_verified_address_state
    t.string :owner_verified_email
    t.string :owner_verified_name
    t.string :owner_verified_phone
  end

  def create_receiver_columns(t)
    t.string :receiver_address
    t.integer :receiver_amount_charged_cents
    t.string :receiver_amount_charged_currency
    t.integer :receiver_amount_received_cents
    t.string :receiver_amount_received_currency
    t.integer :receiver_amount_returned_cents
    t.string :receiver_amount_returned_currency
    t.string :receiver_refund_attributes_method
    t.string :receiver_refund_attributes_status
  end

  def create_ach_columns(t)
    t.string :ach_credit_transfer_account_number
    t.string :ach_credit_transfer_routing_number
    t.string :ach_credit_transfer_fingerprint
    t.string :ach_credit_transfer_bank_name
    t.string :ach_credit_transfer_swift_code
  end
end
