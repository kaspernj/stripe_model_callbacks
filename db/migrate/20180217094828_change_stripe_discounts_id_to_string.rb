class ChangeStripeDiscountsIdToString < ActiveRecord::Migration[5.1]
  def change
    add_column :stripe_discounts, :identifier, :string, after: :id
    add_index :stripe_discounts, :identifier, unique: true
  end
end
