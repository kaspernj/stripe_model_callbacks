class AddNameToStripeCoupons < ActiveRecord::Migration[6.0]
  def change
    add_column :stripe_coupons, :name, :string
  end
end
