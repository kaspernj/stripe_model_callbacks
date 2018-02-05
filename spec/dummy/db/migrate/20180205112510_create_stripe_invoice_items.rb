class CreateStripeInvoiceItems < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_invoice_items do |t|
      t.string :identifier, index: true, null: false
      t.integer :amount_cents
      t.string :amount_currency
      t.string :customer_identifier, index: true
      t.string :currency, null: false
      t.date :datetime
      t.string :description
      t.boolean :discountable, null: false
      t.string :invoice_identifier, index: true
      t.boolean :livemode, null: false
      t.text :metadata
      t.datetime :period_start
      t.datetime :period_end
      t.string :plan_identifier, index: true
      t.boolean :proration, null: false
      t.integer :quantity
      t.string :subscription_identifier, index: true
      t.string :subscription_item
      t.timestamps
    end
  end
end
