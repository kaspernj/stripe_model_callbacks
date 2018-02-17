class RenameStripeSubscriptionsDiscount < ActiveRecord::Migration[5.1]
  def change
    rename_column :stripe_subscriptions, :discount, :stripe_discount_id
  end
end
