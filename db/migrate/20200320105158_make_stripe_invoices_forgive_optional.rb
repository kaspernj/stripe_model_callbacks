class MakeStripeInvoicesForgiveOptional < ActiveRecord::Migration[6.0]
  def change
    change_column_null :stripe_invoices, :forgiven, true
  end
end
