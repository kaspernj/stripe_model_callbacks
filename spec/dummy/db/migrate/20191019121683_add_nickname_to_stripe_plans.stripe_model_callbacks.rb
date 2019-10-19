# This migration comes from stripe_model_callbacks (originally 20180208160046)
class AddNicknameToStripePlans < ActiveRecord::Migration[5.1]
  def change
    add_column :stripe_plans, :nickname, :string
  end
end
