class CreateStripeReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :stripe_reviews, id: false do |t|
      t.string :id, primary: true, null: false
      t.string :stripe_charge_id, index: true
      t.datetime :created
      t.boolean :livemode, default: false, null: false
      t.boolean :open, default: true, null: false
      t.string :reason, index: true
      t.timestamps
    end
  end
end
