class RemoveNameFromStripePlans < ActiveRecord::Migration[5.1]
  def change
    remove_column :stripe_plans, :name, :string
  end
end
