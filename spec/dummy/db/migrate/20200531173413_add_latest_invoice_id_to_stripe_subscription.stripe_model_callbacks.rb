# This migration comes from stripe_model_callbacks (originally 20200529144649)

class AddLatestInvoiceIdToStripeSubscription < ActiveRecord::Migration[6.0]
  def change
    add_reference :stripe_subscriptions, :latest_stripe_invoice, type: :string, index: true
  end
end
