# This migration comes from stripe_model_callbacks (originally 20180217200350)
class ChangeStripeInvoicesToReferenceDiscounts < ActiveRecord::Migration[5.1]
  def change
    remove_column :stripe_invoices, :discount_cents, :integer
    remove_column :stripe_invoices, :discount_currency, :string

    add_column :stripe_invoices, :stripe_discount_id, :string
    add_index :stripe_invoices, :stripe_discount_id
  end
end
