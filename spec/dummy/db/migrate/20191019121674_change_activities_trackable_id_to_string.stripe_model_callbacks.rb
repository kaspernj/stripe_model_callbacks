# This migration comes from stripe_model_callbacks (originally 20180206151132)
class ChangeActivitiesTrackableIdToString < ActiveRecord::Migration[5.1]
  def change
    change_column :activities, :trackable_id, :string
  end
end
