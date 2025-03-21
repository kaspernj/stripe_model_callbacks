# This migration comes from active_record_auditable (originally 20240307212756)
class CreateAuditAuditableTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :audit_auditable_types do |t|
      t.string :name, index: {unique: true}, null: false
      t.timestamps
    end
  end
end
