# This migration comes from stripe_model_callbacks (originally 20210111100523)
class AddStripeIdToStripeDiscounts < ActiveRecord::Migration[6.0]
  def change
    add_column :stripe_discounts, :stripe_id, :string
    add_index :stripe_discounts, :stripe_id
    execute "UPDATE stripe_discounts SET stripe_id = id"
    change_column_null :stripe_discounts, :stripe_id, false
    remove_column :stripe_discounts, :id

    add_column :stripe_discounts, :id, :primary_key
  end
end
