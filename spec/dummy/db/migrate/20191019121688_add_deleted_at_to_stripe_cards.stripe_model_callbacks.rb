# This migration comes from stripe_model_callbacks (originally 20180218092600)
class AddDeletedAtToStripeCards < ActiveRecord::Migration[5.1]
  def change
    add_column :stripe_cards, :deleted_at, :datetime
    add_index :stripe_cards, :deleted_at

    add_column :stripe_sources, :deleted_at, :datetime
    add_index :stripe_sources, :deleted_at
  end
end
