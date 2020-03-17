# This migration comes from stripe_model_callbacks (originally 20200317181224)
class RenameStripeInvoicesApplicationFeeToApplicationFeeAmount < ActiveRecord::Migration[6.0]
  def change
    rename_column :stripe_invoices, :application_fee_cents, :application_fee_amount_cents
    rename_column :stripe_invoices, :application_fee_currency, :application_fee_amount_currency
  end
end
