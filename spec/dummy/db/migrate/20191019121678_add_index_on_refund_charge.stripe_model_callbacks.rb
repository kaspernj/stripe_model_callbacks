# This migration comes from stripe_model_callbacks (originally 20180207185604)
class AddIndexOnRefundCharge < ActiveRecord::Migration[5.1]
  def change
    add_index :stripe_refunds, :stripe_charge_id
  end
end
