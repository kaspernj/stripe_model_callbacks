# This migration comes from stripe_model_callbacks (originally 20180206115805)
class CreateStripeInvoiceItems < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_invoice_items do |t|
      t.string :stripe_id, index: true, null: false
      t.integer :amount_cents
      t.string :amount_currency
      t.string :stripe_customer_id, index: true
      t.string :currency, null: false
      t.date :datetime
      t.datetime :deleted_at, index: true
      t.string :description
      t.boolean :discountable, null: false
      t.string :stripe_invoice_id, index: true
      t.boolean :livemode, default: true, null: false
      t.text :metadata
      t.datetime :period_start
      t.datetime :period_end
      t.string :stripe_plan_id, index: true
      t.boolean :proration, null: false
      t.integer :quantity
      t.string :stripe_subscription_id, index: true
      t.string :subscription_item
      t.timestamps
    end
  end
end
