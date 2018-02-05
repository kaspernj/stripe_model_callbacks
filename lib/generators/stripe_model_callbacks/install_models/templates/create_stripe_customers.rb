class CreateStripeAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_model_callbacks_stripe_customers do |t|
      t.string :identifier, null: false
      t.integer :account_balance, null: false
      t.string :business_vat_id
      t.string :currency, null: false
      t.string :default_source
      t.boolean :delinquent, null: false
      t.string :description
      t.text :discount
      t.string :email
      t.boolean :livemode, null: false
      t.text :metadata
      t.text :shipping
      t.timestamps
    end
  end
end
