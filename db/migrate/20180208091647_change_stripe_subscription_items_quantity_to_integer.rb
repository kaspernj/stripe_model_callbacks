class ChangeStripeSubscriptionItemsQuantityToInteger < ActiveRecord::Migration[5.1]
  def change
    change_column :stripe_subscription_items, :quantity, :integer
  end
end
