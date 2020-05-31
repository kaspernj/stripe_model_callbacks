class AddLatestInvoiceIdToStripeSubscription < ActiveRecord::Migration[6.0]
  def change
    add_column :stripe_subscriptions, :latest_stripe_invoice_id, :string
    add_index :stripe_subscriptions, :latest_stripe_invoice_id
  end
end
