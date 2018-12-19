class AddNewPrimaryIdAndRenameOld < ActiveRecord::Migration[5.2]
  def change
    tables = %w[
      bank_accounts cards charges coupons customers disputes invoice_items invoices
      orders payouts plans products recipients refunds reviews skus sources
      subscription_items subscriptions transfers
    ]

    tables.each do |table|
      table_name = "stripe_#{table}"

      next if column_exists?(table_name, :stripe_id)

      add_column table_name, :stripe_id, :string
      add_index table_name, :stripe_id
      execute "UPDATE #{table_name} SET stripe_id = id"
      change_column_null table_name, :stripe_id, false
      remove_column table_name, :id

      add_column table_name, :id, :primary_key
    end
  end
end
