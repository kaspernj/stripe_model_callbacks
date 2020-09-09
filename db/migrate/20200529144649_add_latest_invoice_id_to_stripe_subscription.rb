class AddLatestInvoiceIdToStripeSubscription < ActiveRecord::Migration[6.0]
  def change
    add_reference :stripe_subscriptions, :latest_stripe_invoice, type: :string, index: true
  end
end
