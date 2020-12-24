class CreateStripeSubscriptionDefaultTaxRates < ActiveRecord::Migration[6.0]
  def change
    create_table :stripe_subscription_default_tax_rates do |t|
      t.references :stripe_subscription, foreign_key: true, null: false
      t.references :stripe_tax_rate, foreign_key: true, null: false
      t.timestamps
    end
  end
end
