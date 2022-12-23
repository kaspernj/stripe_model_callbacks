# This migration comes from stripe_model_callbacks (originally 20221223095244)
class RenameStripeCustomersAccountBalanceToBalance < ActiveRecord::Migration[7.0]
  def change
    rename_column :stripe_customers, :account_balance, :balance
  end
end
