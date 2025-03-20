# This migration comes from active_record_auditable (originally 20240307212826)
class CreateAudits < ActiveRecord::Migration[7.1]
  def change
    create_table :audits do |t|
      t.references :audit_action, foreign_key: true, null: false
      t.references :audit_auditable_type, foreign_key: true, null: false
      t.references :auditable, null: false, polymorphic: true
      t.references :user, polymorphic: true
      t.json :audited_changes
      t.timestamps
    end
  end
end
