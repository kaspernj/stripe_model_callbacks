class CreateStripeCharges < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_charges do |t|
      t.string :identifier, index: true, null: false
      t.integer :amount_cents, null: false
      t.string :amount_currency, null: false
      t.integer :amount_refunded_cents
      t.string :amount_refunded_currency
      t.integer :application_cents
      t.string :application_cents
      t.boolean :captured, null: false
      t.string :currency, null: false
      t.string :customer_identifier, index: true
      t.string :description
      t.string :dispute
      t.string :failure_code
      t.string :failure_message
      t.text :fraud_details
      t.string :invoice
      t.boolean :livemode, null: false
      t.text :metadata
      t.string :on_behalf_of
      t.string :order
      t.text :outcome
      t.boolean :paid
      t.string :receipt_email
      t.string :receipt_number
      t.boolean :refunded, null: false
      t.string :review
      t.text :shipping
      t.text :source
      t.string :source_transfer
      t.string :statement_desciptor
      t.string :status
      t.string :transfer
      t.string :transfer_group
      t.timestamps
    end
  end
end
