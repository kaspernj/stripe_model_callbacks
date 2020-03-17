class AddProductTypeToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :stripe_products, :product_type, :string
  end
end
