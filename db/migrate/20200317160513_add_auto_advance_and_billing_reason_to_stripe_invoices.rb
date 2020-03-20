class AddAutoAdvanceAndBillingReasonToStripeInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :stripe_invoices, :auto_advance, :boolean, default: false
    add_column :stripe_invoices, :billing_reason, :string
  end
end
