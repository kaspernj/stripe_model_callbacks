# This migration comes from stripe_model_callbacks (originally 20200514132247)
class AddStripeIdUniqToStripeInvoices < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    remove_index(:stripe_invoices, :stripe_id)
    add_index(:stripe_invoices, :stripe_id, unique: true)
  end
end
