# This migration comes from stripe_model_callbacks (originally 20180206130408)
class CreateDisputes < ActiveRecord::Migration[5.1]
  def change
    create_table :stripe_disputes do |table|
      table.string :stripe_id, index: true, null: false
      table.datetime :created
      amount_columns(table)
      table.string :balance_transaction_id, index: true
      table.string :stripe_charge_id, index: true
      table.string :currency
      table.text :evidence_access_activity_log
      table.text :evidence_billing_address
      evidence_cancellation_duplicate_columns(table)
      evidence_customer_columns(table)
      table.text :evidence_product_description
      table.text :evidence_receipt
      evidence_refund_service_columns(table)
      evidence_shipping_columns(table)
      table.text :evidence_uncategorized_file
      table.text :evidence_uncategorized_text
      evidence_details_columns(table)
      table.boolean :is_charge_refundable
      table.boolean :livemode
      table.text :metadata
      table.string :reason
      table.string :status
      table.timestamps
    end
  end

private

  def amount_columns(table)
    table.integer :amount_cents
    table.string :amount_currency
  end

  def evidence_cancellation_duplicate_columns(table)
    table.text :evidence_cancellation_policy
    table.text :evidence_cancellation_policy_disclosure
    table.text :evidence_cancellation_rebuttal
    table.text :evidence_duplicate_charge_documentation
    table.text :evidence_duplicate_charge_explanation
    table.string :evidence_duplicate_charge_id
  end

  def evidence_customer_columns(table)
    table.text :evidence_customer_communication
    table.string :evidence_customer_email_address
    table.string :evidence_customer_name
    table.string :evidence_customer_purchase_ip
    table.text :evidence_customer_signature
  end

  def evidence_refund_service_columns(table)
    table.text :evidence_refund_policy
    table.text :evidence_refund_policy_disclosure
    table.text :evidence_refund_refusal_explanation
    table.text :evidence_service_date
    table.text :evidence_service_documentation
  end

  def evidence_shipping_columns(table)
    table.text :evidence_shipping_address
    table.text :evidence_shipping_carrier
    table.text :evidence_shipping_date
    table.text :evidence_shipping_documentation
    table.text :evidence_shipping_tracking_number
  end

  def evidence_details_columns(table)
    table.datetime :evidence_details_due_by
    table.boolean :evidence_details_has_evidence
    table.boolean :evidence_details_past_due
    table.integer :evidence_details_submission_count
  end
end
