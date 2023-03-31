# This migration comes from stripe_model_callbacks (originally 20230331182902)
class AddAmountCapturedToStripeCharges < ActiveRecord::Migration[7.0]
  def change
    add_column :stripe_charges, :amount_captured_cents, :integer
    add_column :stripe_charges, :amount_captured_currency, :string
  end
end
