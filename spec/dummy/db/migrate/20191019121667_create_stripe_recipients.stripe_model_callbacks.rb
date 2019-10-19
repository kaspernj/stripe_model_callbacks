# This migration comes from stripe_model_callbacks (originally 20180206115812)
class CreateStripeRecipients < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_recipients do |t|
      t.string :stripe_id, index: true, null: false
      t.string :active_account
      t.string :description
      t.datetime :deleted_at, index: true
      t.string :name
      t.string :email
      t.boolean :livemode, default: true, null: false
      t.string :stripe_type
      t.text :metadata
      t.string :migrated_to
      t.boolean :verified, default: false, null: false
      t.timestamps
    end
  end
end
