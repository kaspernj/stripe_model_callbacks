# This migration comes from stripe_model_callbacks (originally 20200320114859)
class MakeStripeInvoiceClosedOptional < ActiveRecord::Migration[6.0]
  def change
    change_column_null :stripe_invoices, :closed, true
  end
end
