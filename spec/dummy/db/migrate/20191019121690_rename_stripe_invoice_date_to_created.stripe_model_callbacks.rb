# This migration comes from stripe_model_callbacks (originally 20190629112050)
class RenameStripeInvoiceDateToCreated < ActiveRecord::Migration[5.2]
  def change
    rename_column :stripe_invoices, :date, :created
  end
end
