class CreateStripeCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_customers, id: false do |t|
      t.string :id, primary: true, null: false
      t.integer :account_balance, null: false
      t.string :business_vat_id
      t.datetime :deleted_at, index: true
      t.string :currency
      t.string :default_source
      t.boolean :delinquent, null: false
      t.string :description
      t.text :discount
      t.string :email
      t.boolean :livemode, null: false
      t.text :metadata
      t.text :shipping
      t.datetime :created
      t.timestamps
    end
  end
end
