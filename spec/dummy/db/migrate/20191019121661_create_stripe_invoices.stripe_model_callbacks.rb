# This migration comes from stripe_model_callbacks (originally 20180206115806)
class CreateStripeInvoices < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_invoices do |table|
      table.string :stripe_id, index: true, null: false
      amount_columns(table)
      customer_columns(table)
      table.boolean :attempted, null: false
      table.datetime :next_payment_attempt
      table.boolean :closed, null: false
      table.datetime :date, null: false
      table.datetime :due_date
      table.boolean :livemode, default: true, null: false
      table.text :metadata
      table.string :number
      table.boolean :paid, null: false
      table.datetime :period_start
      table.datetime :period_end
      table.integer :starting_balance_cents
      table.string :starting_balance_currency
      table.string :statement_descriptor
      table.datetime :subscription_proration_date
      table.datetime :webhooks_delivered_at
      table.timestamps
    end
  end

private

  def amount_columns(table)
    table.integer :amount_due_cents, null: false
    table.string :amount_due_currency, null: false
    table.integer :application_fee_cents
    table.string :application_fee_currency
    table.string :billing, null: false
    table.integer :discount_cents
    table.string :discount_currency
    table.integer :ending_balance_cents
    table.integer :ending_balance_currency
    table.string :stripe_charge_id, index: true
    table.string :currency, null: false
    table.integer :subtotal_cents
    table.string :subtotal_currency
    table.integer :tax_cents
    table.string :tax_currency
    table.decimal :tax_percent
    table.integer :total_cents
    table.string :total_currency
  end

  def customer_columns(table)
    table.string :stripe_customer_id, index: true, null: false
    table.string :description
    table.boolean :forgiven, null: false
    table.string :receipt_number
    table.string :stripe_subscription_id, index: true
  end
end
