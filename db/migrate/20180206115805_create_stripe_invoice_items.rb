class CreateStripeInvoiceItems < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_invoice_items, id: false do |t|
      t.string :id, primary: true, null: false
      t.integer :amount_cents
      t.string :amount_currency
      t.string :stripe_customer_id, index: true
      t.string :currency, null: false
      t.date :datetime
      t.datetime :deleted_at, index: true
      t.string :description
      t.boolean :discountable, null: false
      t.string :stripe_invoice_id, index: true
      t.boolean :livemode, null: false
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
