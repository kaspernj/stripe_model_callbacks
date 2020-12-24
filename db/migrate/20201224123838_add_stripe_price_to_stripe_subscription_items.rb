class AddStripePriceToStripeSubscriptionItems < ActiveRecord::Migration[6.0]
  def change
    add_column :stripe_subscription_items, :stripe_price_id, :string
    add_index :stripe_subscription_items, :stripe_price_id
  end
end
