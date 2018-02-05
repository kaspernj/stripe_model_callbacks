class CreateStripeRecipients < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_recipients do |t|
      t.string :identifier, index: true, null: false
      t.string :active_account
      t.string :description
      t.datetime :deleted_at, index: true
      t.string :name
      t.string :email
      t.boolean :livemode, default: false, null: false
      t.string :stripe_type
      t.text :metadata
      t.string :migrated_to
      t.boolean :verified, default: false, null: false
      t.timestamps
    end
  end
end
