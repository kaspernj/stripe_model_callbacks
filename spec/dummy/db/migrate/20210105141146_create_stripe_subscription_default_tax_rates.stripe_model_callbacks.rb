# This migration comes from stripe_model_callbacks (originally 20201224120534)
class CreateStripeSubscriptionDefaultTaxRates < ActiveRecord::Migration[6.0]
  def change
    create_table :stripe_subscription_default_tax_rates do |t|
      t.references :stripe_subscription, foreign_key: true, index: {name: "index_on_subscription"}, null: false
      t.references :stripe_tax_rate, foreign_key: true, index: {name: "index_on_tax_rate"}, null: false
      t.timestamps
    end
  end
end
