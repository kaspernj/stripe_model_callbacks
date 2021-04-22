class RenameStripeSubscriptionsStartToStartDate < ActiveRecord::Migration[6.0]
  def change
    rename_column :stripe_subscriptions, :start, :start_date
  end
end
