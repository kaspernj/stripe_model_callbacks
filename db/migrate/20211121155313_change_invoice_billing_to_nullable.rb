class ChangeInvoiceBillingToNullable < ActiveRecord::Migration[6.1]
  def change
    change_column_null :stripe_invoices, :billing, true
  end
end
