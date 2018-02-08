class AddNicknameToStripePlans < ActiveRecord::Migration[5.1]
  def change
    add_column :stripe_plans, :nickname, :string
  end
end
