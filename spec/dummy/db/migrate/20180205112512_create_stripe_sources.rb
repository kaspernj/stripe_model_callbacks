class CreateStripeSources < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_sources do |t|
      t.string :identifier, index: true, null: false
      t.integer :amount_cents
      t.string :amount_currency
      t.string :client_secret, null: false
      t.string :currency
      t.string :flow, null: false
      t.boolean :livemode, null: false
      t.string :metadata
      t.timestamps
    end
  end
end
