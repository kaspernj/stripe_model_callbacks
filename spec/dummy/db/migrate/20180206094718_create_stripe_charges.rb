class CreateStripeCharges < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_charges do |t|
      t.string :identifier, index: true, null: false
      amount_columns(t)
      dispute_failure_and_fraud_columns(t)
      recipient_columns(t)
      t.boolean :livemode, null: false
      t.text :metadata
      t.string :source_transfer
      t.string :statement_descriptor
      t.string :status
      t.string :transfer_group
      t.datetime :created
      t.timestamps
    end
  end

private

  def amount_columns(t)
    t.integer :amount_cents, null: false
    t.string :amount_currency, null: false
    t.integer :amount_refunded_cents
    t.string :amount_refunded_currency
    t.integer :application_cents
    t.string :application_currency
    t.string :currency, null: false
    t.boolean :captured, null: false
    t.boolean :paid, null: false
  end

  def dispute_failure_and_fraud_columns(t)
    t.string :dispute
    t.string :failure_code
    t.string :failure_message
    t.text :fraud_details
    t.text :outcome
    t.boolean :refunded, null: false
    t.string :review
  end

  def recipient_columns(t)
    t.string :description
    t.string :customer_identifier, index: true
    t.string :order_identifier, index: true
    t.string :source_identifier, index: true
    t.string :invoice_identifier, index: true
    t.string :on_behalf_of
    t.string :receipt_email
    t.string :receipt_number
    t.text :shipping
  end
end
