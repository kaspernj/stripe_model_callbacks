class CreateStripePayouts < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_payouts do |t|
      t.string :identifier, index: true, null: false
      t.integer :amount_cents
      t.string :amount_currency
      t.datetime :arrival_date
      t.boolean :automatic
      t.string :balance_transaction
      t.datetime :created
      t.string :currency
      t.string :description
      t.string :destination
      t.string :failure_balance_transaction
      t.string :failure_code
      t.string :failure_message
      t.boolean :livemode
      t.text :metadata
      t.string :stripe_method
      t.string :source_type
      t.string :statement_descriptor
      t.string :status
      t.string :stripe_type
      t.timestamps
    end
  end
end
