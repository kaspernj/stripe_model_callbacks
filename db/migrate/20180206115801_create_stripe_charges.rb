class CreateStripeCharges < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_charges do |table|
      table.string :stripe_id, index: true, null: false
      amount_columns(table)
      dispute_failure_and_fraud_columns(table)
      recipient_columns(table)
      table.boolean :livemode, default: true, null: false
      table.text :metadata
      table.string :source_transfer
      table.string :statement_descriptor
      table.string :status
      table.string :transfer_group
      table.datetime :created
      table.timestamps
    end
  end

private

  def amount_columns(table)
    table.integer :amount_cents, null: false
    table.string :amount_currency, null: false
    table.integer :amount_refunded_cents
    table.string :amount_refunded_currency
    table.integer :application_cents
    table.string :application_currency
    table.string :currency, null: false
    table.boolean :captured, null: false
    table.boolean :paid, null: false
  end

  def dispute_failure_and_fraud_columns(table)
    table.string :dispute
    table.string :failure_code
    table.string :failure_message
    table.text :fraud_details
    table.text :outcome
    table.boolean :refunded, null: false
    table.string :review
  end

  def recipient_columns(table)
    table.string :description
    table.string :stripe_customer_id, index: true
    table.string :stripe_order_id, index: true
    table.string :stripe_source_id, index: true
    table.string :stripe_invoice_id, index: true
    table.string :on_behalf_of
    table.string :receipt_email
    table.string :receipt_number
    table.text :shipping
  end
end
