# This migration comes from stripe_model_callbacks (originally 20201223202117)
class CreateStripeTaxRates < ActiveRecord::Migration[6.0]
  def change
    create_table :stripe_tax_rates do |t|
      t.string :stripe_id, index: true, null: false
      t.string :display_name
      t.text :description
      t.string :jurisdiction
      t.float :percentage
      t.boolean :inclusive
      t.boolean :active
      t.timestamp :created
      t.timestamps
    end
  end
end
