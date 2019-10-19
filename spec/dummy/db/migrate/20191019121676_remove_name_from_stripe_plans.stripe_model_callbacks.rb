# This migration comes from stripe_model_callbacks (originally 20180207171559)
class RemoveNameFromStripePlans < ActiveRecord::Migration[5.1]
  def change
    remove_column :stripe_plans, :name, :string
  end
end
