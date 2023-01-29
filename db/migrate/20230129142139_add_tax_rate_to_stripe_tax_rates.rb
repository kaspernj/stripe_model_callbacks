class AddTaxRateToStripeTaxRates < ActiveRecord::Migration[7.0]
  def change
    add_column :stripe_tax_rates, :tax_type, :string
  end
end
