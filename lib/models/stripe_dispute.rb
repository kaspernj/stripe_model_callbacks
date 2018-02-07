class StripeDispute < StripeModelCallbacks::ApplicationRecord
  self.primary_key = "id"

  monetize :amount_cents

  def self.stripe_class
    Stripe::Dispute
  end

  def assign_from_stripe(object)
    assign_attributes(
      amount: Money.new(object.amount, object.currency),
      balance_transaction_id: object.balance_transaction,
      stripe_charge_id: object.charge,
      created: Time.zone.at(object.created),
      metadata: JSON.generate(object.metadata)
    )

    assign_evidence_attributes(object)
    assign_evidence_cancellation_duplicate_attributes(object)
    assign_evidence_customer_attributes(object)
    assign_evidence_shipping_attributes(object)
    assign_evidence_details_attributes(object)

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self, stripe_model: object,
      attributes: %w[currency livemode reason status is_charge_refundable]
    )
  end

private

  def assign_evidence_attributes(object)
    assign_attributes(
      evidence_access_activity_log: object.evidence.access_activity_log,
      evidence_billing_address: object.evidence.billing_address,
      evidence_product_description: object.evidence.product_description,
      evidence_receipt: object.evidence.receipt,
      evidence_refund_policy: object.evidence.refund_policy,
      evidence_refund_policy_disclosure: object.evidence.refund_policy_disclosure,
      evidence_refund_refusal_explanation: object.evidence.refund_refusal_explanation,
      evidence_service_date: object.evidence.service_date,
      evidence_service_documentation: object.evidence.service_documentation,
      evidence_uncategorized_file: object.evidence.uncategorized_file,
      evidence_uncategorized_text: object.evidence.uncategorized_text
    )
  end

  def assign_evidence_cancellation_duplicate_attributes(object)
    assign_attributes(
      evidence_cancellation_policy: object.evidence.cancellation_policy,
      evidence_cancellation_policy_disclosure: object.evidence.cancellation_policy_disclosure,
      evidence_cancellation_rebuttal: object.evidence.cancellation_rebuttal,
      evidence_duplicate_charge_documentation: object.evidence.duplicate_charge_documentation,
      evidence_duplicate_charge_explanation: object.evidence.duplicate_charge_explanation,
      evidence_duplicate_charge_id: object.evidence.duplicate_charge_id
    )
  end

  def assign_evidence_customer_attributes(object)
    assign_attributes(
      evidence_customer_communication: object.evidence.customer_communication,
      evidence_customer_email_address: object.evidence.customer_email_address,
      evidence_customer_name: object.evidence.customer_name,
      evidence_customer_purchase_ip: object.evidence.customer_purchase_ip,
      evidence_customer_signature: object.evidence.customer_signature
    )
  end

  def assign_evidence_shipping_attributes(object)
    assign_attributes(
      evidence_shipping_address: object.evidence.shipping_address,
      evidence_shipping_carrier: object.evidence.shipping_carrier,
      evidence_shipping_date: object.evidence.shipping_date,
      evidence_shipping_documentation: object.evidence.shipping_documentation,
      evidence_shipping_tracking_number: object.evidence.shipping_tracking_number
    )
  end

  def assign_evidence_details_attributes(object)
    assign_attributes(
      evidence_details_due_by: Time.zone.at(object.evidence_details.due_by),
      evidence_details_has_evidence: object.evidence_details.has_evidence,
      evidence_details_past_due: object.evidence_details.past_due,
      evidence_details_submission_count: object.evidence_details.submission_count
    )
  end
end
