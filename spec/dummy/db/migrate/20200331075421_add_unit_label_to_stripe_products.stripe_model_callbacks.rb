# This migration comes from stripe_model_callbacks (originally 20200331074940)
class AddUnitLabelToStripeProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :stripe_products, :unit_label, :string
  end
end
