class CreateStripePaymentMethods < ActiveRecord::Migration[7.0]
  def change
    create_table :stripe_payment_methods do |t|
      t.string :stripe_id, index: {unique: true}, null: false
      t.json :billing_details
      t.json :card
      t.json :metadata
      t.string :customer
      t.string :stripe_type
      t.boolean :livemode
      t.integer :created
      t.timestamps
    end
  end
end
