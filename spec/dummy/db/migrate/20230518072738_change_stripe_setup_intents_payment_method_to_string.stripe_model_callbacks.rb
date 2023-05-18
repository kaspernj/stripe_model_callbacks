# This migration comes from stripe_model_callbacks (originally 20230518072538)
class ChangeStripeSetupIntentsPaymentMethodToString < ActiveRecord::Migration[7.0]
  def change
    rename_column :stripe_setup_intents, :payment_method, :payment_method_old
    add_column :stripe_setup_intents, :payment_method, :string
    add_index :stripe_setup_intents, :payment_method
  end
end
