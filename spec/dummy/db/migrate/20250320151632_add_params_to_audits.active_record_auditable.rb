# This migration comes from active_record_auditable (originally 20240609073430)
class AddParamsToAudits < ActiveRecord::Migration[7.1]
  def change
    add_column :audits, :params, :json
  end
end
