class CreateStripeRefunds < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_refunds do |t|
      t.string :stripe_id, index: true, null: false
      t.integer :amount_cents
      t.string :amount_currency
      t.string :balance_transaction
      t.string :stripe_charge_id, null: false
      t.string :currency, null: false
      t.string :failure_balance_transaction
      t.string :failure_reason
      t.boolean :livemode, default: true, null: false
      t.text :metadata
      t.string :reason
      t.string :receipt_number
      t.string :status
      t.datetime :created
      t.timestamps
    end
  end
end
