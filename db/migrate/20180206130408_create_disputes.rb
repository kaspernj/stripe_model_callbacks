class CreateDisputes < ActiveRecord::Migration[5.1]
  def change
    create_table :stripe_disputes do |t|
      t.string :identifier, index: true, null: false
      t.datetime :created
      t.integer :amount_cents
      t.string :amount_currency
      t.string :balance_transaction_identifier
      t.string :charge_identifier
      t.string :currency
      t.text :evidence_access_activity_log
      t.text :evidence_billing_address
      t.text :evidence_cancellation_policy
      t.text :evidence_cancellation_policy_disclosure
      t.text :evidence_cancellation_rebuttal
      t.text :evidence_customer_communication
      t.string :evidence_customer_email_address
      t.string :evidence_customer_name
      t.string :evidence_customer_purchase_ip
      t.text :evidence_customer_signature
      t.text :evidence_duplicate_charge_documentation
      t.text :evidence_duplicate_charge_explanation
      t.string :evidence_duplicate_charge_id
      t.text :evidence_product_description
      t.text :evidence_receipt
      t.text :evidence_refund_policy
      t.text :evidence_refund_policy_disclosure
      t.text :evidence_refund_refusal_explanation
      t.text :evidence_service_date
      t.text :evidence_service_documentation
      t.text :evidence_shipping_address
      t.text :evidence_shipping_carrier
      t.text :evidence_shipping_date
      t.text :evidence_shipping_documentation
      t.text :evidence_shipping_tracking_number
      t.text :evidence_uncategorized_file
      t.text :evidence_uncategorized_text
      t.datetime :evidence_details_due_by
      t.boolean :evidence_details_has_evidence
      t.boolean :evidence_details_past_due
      t.integer :evidence_details_submission_count
      t.boolean :is_charge_refundable
      t.boolean :livemode
      t.text :metadata
      t.string :reason
      t.string :status
      t.timestamps
    end
  end
end
