class ChangeStripeRefundsStripeChargeIdToNullable < ActiveRecord::Migration[7.0]
  def change
    change_column_null :stripe_refunds, :stripe_charge_id, true
  end
end
