# This migration comes from stripe_model_callbacks (originally 20230129142139)
class AddTaxRateToStripeTaxRates < ActiveRecord::Migration[7.0]
  def change
    add_column :stripe_tax_rates, :tax_type, :string
  end
end
