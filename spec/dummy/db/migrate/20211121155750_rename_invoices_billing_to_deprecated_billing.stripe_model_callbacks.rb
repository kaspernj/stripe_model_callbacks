# This migration comes from stripe_model_callbacks (originally 20211121155732)
class RenameInvoicesBillingToDeprecatedBilling < ActiveRecord::Migration[6.1]
  def change
    rename_column :stripe_invoices, :billing, :billing_deprecated
  end
end
