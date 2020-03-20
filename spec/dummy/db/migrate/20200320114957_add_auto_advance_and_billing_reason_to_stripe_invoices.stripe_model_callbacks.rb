# This migration comes from stripe_model_callbacks (originally 20200317160513)
class AddAutoAdvanceAndBillingReasonToStripeInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :stripe_invoices, :auto_advance, :boolean, default: false
    add_column :stripe_invoices, :billing_reason, :string
  end
end
