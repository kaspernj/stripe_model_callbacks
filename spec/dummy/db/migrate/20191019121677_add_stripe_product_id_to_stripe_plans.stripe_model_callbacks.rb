# This migration comes from stripe_model_callbacks (originally 20180207172011)
class AddStripeProductIdToStripePlans < ActiveRecord::Migration[5.1]
  def change
    add_column :stripe_plans, :stripe_product_id, :string
    add_index :stripe_plans, :stripe_product_id
  end
end
