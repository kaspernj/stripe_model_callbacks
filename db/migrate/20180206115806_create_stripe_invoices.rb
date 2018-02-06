class CreateStripeInvoices < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_invoices, id: false do |t|
      t.string :id, primary: true, null: false
      amount_columns(t)
      customer_columns(t)
      t.boolean :attempted, null: false
      t.datetime :next_payment_attempt
      t.boolean :closed, null: false
      t.datetime :date, null: false
      t.datetime :due_date
      t.boolean :livemode, null: false
      t.text :metadata
      t.string :number
      t.boolean :paid, null: false
      t.datetime :period_start
      t.datetime :period_end
      t.integer :starting_balance_cents
      t.string :starting_balance_currency
      t.string :statement_descriptor
      t.datetime :subscription_proration_date
      t.datetime :webhooks_delivered_at
      t.timestamps
    end
  end

private

  def amount_columns(t)
    t.integer :amount_due_cents, null: false
    t.string :amount_due_currency, null: false
    t.integer :application_fee_cents
    t.string :application_fee_currency
    t.string :billing, null: false
    t.integer :discount_cents
    t.string :discount_currency
    t.integer :ending_balance_cents
    t.integer :ending_balance_currency
    t.string :stripe_charge_id, index: true
    t.string :currency, null: false
    t.integer :subtotal_cents
    t.string :subtotal_currency
    t.integer :tax_cents
    t.string :tax_currency
    t.decimal :tax_percent
    t.integer :total_cents
    t.string :total_currency
  end

  def customer_columns(t)
    t.string :stripe_customer_id, index: true, null: false
    t.string :description
    t.boolean :forgiven, null: false
    t.string :receipt_number
    t.string :stripe_subscription_id, index: true
  end
end
