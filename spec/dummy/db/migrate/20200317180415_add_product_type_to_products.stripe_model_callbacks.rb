# This migration comes from stripe_model_callbacks (originally 20200317180115)
class AddProductTypeToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :stripe_products, :product_type, :string
  end
end
