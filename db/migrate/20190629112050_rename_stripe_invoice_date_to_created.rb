class RenameStripeInvoiceDateToCreated < ActiveRecord::Migration[5.2]
  def change
    rename_column :stripe_invoices, :date, :created
  end
end
