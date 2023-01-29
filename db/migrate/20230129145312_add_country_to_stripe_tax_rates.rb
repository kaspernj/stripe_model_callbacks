class AddCountryToStripeTaxRates < ActiveRecord::Migration[7.0]
  def change
    add_column :stripe_tax_rates, :country, :string
  end
end
