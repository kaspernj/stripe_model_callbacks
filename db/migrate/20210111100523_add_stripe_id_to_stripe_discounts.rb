class AddStripeIdToStripeDiscounts < ActiveRecord::Migration[6.0]
  def up
    add_column :stripe_discounts, :stripe_id, :string
    add_index :stripe_discounts, :stripe_id
    execute "UPDATE stripe_discounts SET stripe_id = id"
    change_column_null :stripe_discounts, :stripe_id, false
    remove_column :stripe_discounts, :id

    add_column :stripe_discounts, :id, :primary_key
  end

  def down
    remove_column :stripe_discounts, :id
    add_column :stripe_discounts, :id, :string, primary_key: true
    execute "UPDATE stripe_discounts SET id = stripe_id"
    change_column_null :stripe_discounts, :id, false
    remove_column :stripe_discounts, :stripe_id
  end
end
