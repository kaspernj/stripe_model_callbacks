class CreateActivities < ActiveRecord::Migration[5.0]
  def up
    create_table :activities do |t|
      t.belongs_to :stripe_trackable, polymorphic: true
      t.belongs_to :stripe_owner, polymorphic: true
      t.string :key
      t.text :parameters
      t.belongs_to :stripe_recipient, polymorphic: true
      t.timestamps
    end

    add_index :activities, [:trackable_id, :trackable_type]
    add_index :activities, [:owner_id, :owner_type]
    add_index :activities, [:recipient_id, :recipient_type]
  end

  def down
    drop_table :activities
  end
end
