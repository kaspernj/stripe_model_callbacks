# This migration comes from stripe_model_callbacks (originally 20230422074329)
class AddPaymentIntentToStripeCharges < ActiveRecord::Migration[7.0]
  def change
    add_column :stripe_charges, :payment_intent, :string
    add_index :stripe_charges, :payment_intent
  end
end
