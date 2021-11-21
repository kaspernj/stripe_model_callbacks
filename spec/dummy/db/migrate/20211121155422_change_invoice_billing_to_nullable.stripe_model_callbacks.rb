# This migration comes from stripe_model_callbacks (originally 20211121155313)
class ChangeInvoiceBillingToNullable < ActiveRecord::Migration[6.1]
  def change
    change_column_null :stripe_invoices, :billing, true
  end
end
