class CreateStripeInvoices < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_invoices do |t|
      t.string :identifier, index: true, null: false
      t.integer :amount_due_cents, null: false
      t.string :amount_due_currency, null: false
      t.integer :application_fee_cents
      t.string :application_fee_currency
      t.boolean :attempted, null: false
      t.string :billing, null: false
      t.string :charge_identifier, index: true
      t.boolean :closed, null: false
      t.string :currency, null: false
      t.string :customer_identifier, index: true, null: false
      t.datetime :date, null: false
      t.string :description
      t.integer :discount_cents
      t.string :discount_currency
      t.datetime :due_date
      t.integer :ending_balance_cents
      t.integer :ending_balance_currency
      t.boolean :forgiven, null: false
      t.boolean :livemode, null: false
      t.text :metadata
      t.datetime :next_payment_attempt
      t.string :number
      t.boolean :paid, null: false
      t.datetime :period_start
      t.datetime :period_end
      t.string :receipt_number
      t.integer :starting_balance_cents
      t.string :starting_balance_currency
      t.string :statement_descriptor
      t.string :subscription_identifier, index: true
      t.datetime :subscription_proration_date
      t.integer :subtotal_cents
      t.string :subtotal_currency
      t.integer :tax_cents
      t.string :tax_currency
      t.decimal :tax_percent
      t.integer :total_cents
      t.string :total_currency
      t.datetime :webhooks_delivered_at
      t.timestamps
    end
  end
end
