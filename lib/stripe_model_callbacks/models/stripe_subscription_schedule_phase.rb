class StripeSubscriptionSchedulePhase < StripeModelCallbacks::ApplicationRecord
  belongs_to :stripe_subscription_schedule, primary_key: "stripe_id"

  has_many :subscription_schedule_phase_plans, primary_key: "stripe_id"

  def assign_from_phase_hash(phase_hash)
    assign_attributes(
      end_date: Time.zone.at(phase_hash.dig(:end_date)),
      start_date: Time.zone.at(phase_hash.dig(:start_date)),
      trial_end: Time.zone.at(phase_hash.dig(:trial_end)),
      **phase_hash.slice(
        %w[
          application_fee_percent
          collection_method
          default_payment_method
          prorate
          proration_behavior
        ]
      )
    )

    assign_billing_thresholds(phase_hash)
    assign_invoice_settings(phase_hash)
  end

  def assign_billing_thresholds(phase_hash)
    billing_thresholds = phase_hash.dig(:billing_thresholds)

    self.billing_thresholds_amount_gte = billing_thresholds&.dig(:amount_gte)
    self.billing_thresholds_reset_billing_cycle_anchor = billing_thresholds&.dig(:reset_billing_cycle_anchor)
  end

  def assign_invoice_settings(phase_hash)
    invoice_settings = phase_hash.dig(:invoice_settings)

    self.invoice_settings_days_until_due = invoice_settings&.dig(:days_until_due)
  end
end
