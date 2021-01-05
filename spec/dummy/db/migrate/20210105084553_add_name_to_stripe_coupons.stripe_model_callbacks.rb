# This migration comes from stripe_model_callbacks (originally 20210105084024)
class AddNameToStripeCoupons < ActiveRecord::Migration[6.0]
  def change
    add_column :stripe_coupons, :name, :string
  end
end
