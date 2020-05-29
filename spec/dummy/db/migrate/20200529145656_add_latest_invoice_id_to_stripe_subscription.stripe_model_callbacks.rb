# frozen_string_literal: true
# This migration comes from stripe_model_callbacks (originally 20200529144649)

class AddLatestInvoiceIdToStripeSubscription < ActiveRecord::Migration[6.0]
  def change
    add_column :stripe_subscriptions, :latest_stripe_invoice_id, :string
    add_index :stripe_subscriptions, :latest_stripe_invoice_id
  end
end
