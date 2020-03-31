class AddUnitLabelToStripeProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :stripe_products, :unit_label, :string
  end
end
