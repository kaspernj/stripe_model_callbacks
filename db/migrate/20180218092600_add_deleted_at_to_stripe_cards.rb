class AddDeletedAtToStripeCards < ActiveRecord::Migration[5.1]
  def change
    add_column :stripe_cards, :deleted_at, :datetime
    add_index :stripe_cards, :deleted_at

    add_column :stripe_sources, :deleted_at, :datetime
    add_index :stripe_sources, :deleted_at
  end
end
