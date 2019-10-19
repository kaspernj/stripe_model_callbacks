# This migration comes from stripe_model_callbacks (originally 20181219121712)
class AddNewPrimaryIdAndRenameOld < ActiveRecord::Migration[5.2]
  TABLES = %w[
    bank_accounts cards charges coupons customers disputes invoice_items invoices
    orders payouts plans products recipients refunds reviews skus sources
    subscription_items subscriptions transfers
  ].freeze

  def up
    TABLES.each do |table|
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

  def down
    TABLES.each do |table|
      table_name = "stripe_#{table}"

      next unless column_exists?(table_name, :stripe_id)

      remove_column table_name, :id
      add_column table_name, :id, :string, primary_key: true
      execute "UPDATE #{table_name} SET id = stripe_id"
      change_column_null table_name, :id, false
      remove_column table_name, :stripe_id
    end
  end
end
