class CreateStripeDiscounts < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_discounts do |t|
      t.string :identifier, index: true, null: false
      t.datetime :created
      t.timestamps
    end
  end
end
