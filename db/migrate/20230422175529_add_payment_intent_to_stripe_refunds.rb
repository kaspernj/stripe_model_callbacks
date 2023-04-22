class AddPaymentIntentToStripeRefunds < ActiveRecord::Migration[7.0]
  def change
    add_column :stripe_refunds, :payment_intent, :string
    add_index :stripe_refunds, :payment_intent
  end
end
