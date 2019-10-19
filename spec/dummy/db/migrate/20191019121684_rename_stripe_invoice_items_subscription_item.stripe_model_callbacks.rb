# This migration comes from stripe_model_callbacks (originally 20180211092437)
class RenameStripeInvoiceItemsSubscriptionItem < ActiveRecord::Migration[5.1]
  def change
    rename_column :stripe_invoice_items, :subscription_item, :stripe_subscription_item_id
    add_index :stripe_invoice_items, :stripe_subscription_item_id
  end
end
