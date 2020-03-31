# This migration comes from stripe_model_callbacks (originally 20200331075241)
class AddMeteredInfoToStripePlans < ActiveRecord::Migration[6.0]
  def change
    add_column :stripe_plans, :active, :boolean
    add_column :stripe_plans, :aggregate_usage, :string
    add_column :stripe_plans, :amount_decimal, :string
    add_column :stripe_plans, :billing_scheme, :string
    add_column :stripe_plans, :usage_type, :string
  end
end
