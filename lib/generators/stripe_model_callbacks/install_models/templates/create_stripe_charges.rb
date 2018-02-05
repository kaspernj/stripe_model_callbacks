class CreateStripeAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_model_callbacks_stripe_charges do |t|
      t.string :identifier, null: false
      t.integer :amount_cents, null: false
      t.string :amount_currency, null: false
      t.integer :amount_refunded_cents
      t.string :amount_refunded_currency
      t.integer :application_cents
      t.string :application_cents
      t.boolean :captured, null: false
      t.string :currency, null: false
      t.string :customer
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
      t.transfer :string
      t.transfer_group :string
      t.timestamps
    end
  end
end
