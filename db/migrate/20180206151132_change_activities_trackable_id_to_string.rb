class ChangeActivitiesTrackableIdToString < ActiveRecord::Migration[5.1]
  def change
    change_column :activities, :trackable_id, :string
  end
end
