class RenameStripeCustomersAccountBalanceToBalance < ActiveRecord::Migration[7.0]
  def change
    rename_column :stripe_customers, :account_balance, :balance
  end
end
