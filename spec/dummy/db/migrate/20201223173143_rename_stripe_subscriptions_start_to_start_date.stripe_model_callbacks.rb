# This migration comes from stripe_model_callbacks (originally 20201223173035)
class RenameStripeSubscriptionsStartToStartDate < ActiveRecord::Migration[6.0]
  def change
    rename_column :stripe_subscriptions, :start, :start_date
  end
end
