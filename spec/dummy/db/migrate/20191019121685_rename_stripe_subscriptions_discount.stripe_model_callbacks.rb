# This migration comes from stripe_model_callbacks (originally 20180216224335)
class RenameStripeSubscriptionsDiscount < ActiveRecord::Migration[5.1]
  def change
    rename_column :stripe_subscriptions, :discount, :stripe_discount_id
  end
end
