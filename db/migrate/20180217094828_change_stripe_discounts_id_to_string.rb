class ChangeStripeDiscountsIdToString < ActiveRecord::Migration[5.1]
  def change
    change_column :stripe_discounts, :id, :string

    if index_exists?(:stripe_discounts, "sqlite_autoindex_stripe_discounts_1")
      remove_index :stripe_discounts, "sqlite_autoindex_stripe_discounts_1"
    end
  end
end
