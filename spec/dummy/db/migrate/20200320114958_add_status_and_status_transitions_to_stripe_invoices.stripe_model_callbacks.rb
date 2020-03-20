# This migration comes from stripe_model_callbacks (originally 20200317160602)
class AddStatusAndStatusTransitionsToStripeInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :stripe_invoices, :status, :string, default: "draft", nil: false

    add_column :stripe_invoices, :finalized_at, :datetime
    add_column :stripe_invoices, :marked_uncollectible_at, :datetime
    add_column :stripe_invoices, :paid_at, :datetime
    add_column :stripe_invoices, :voided_at, :datetime
  end
end
