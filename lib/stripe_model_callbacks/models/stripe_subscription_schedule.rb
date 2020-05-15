class StripeSubscriptionSchedule < StripeModelCallbacks::ApplicationRecord
  has_many :subscription_schedule_phases, primary_key: "stripe_id"

  def self.stripe_class
    Stripe::SubscriptionSchedule
  end

  def assign_from_stripe(object)
    assign_attributes(
      completed_at: Time.zone.at(object.completed_at),
      created: Time.zone.at(object.created),
      metadata: JSON.generate(object.metadata),
      released_at: Time.zone.at(object.released_at),
      released_stripe_subscription_id: object.released_subscription,
      stripe_customer_id: object.customer,
      stripe_subscription_id: object.subscription
    )

    assign_billing_thresholds(object)
    assign_current_phase(object)
    assign_invoice_settings(object)

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self,
      stripe_model: object,
      attributes: %w[
        billing canceled_at collection_method
        default_payment_method default_source
        end_behavior livemode
        renewal_behavior renewal_interval
        status
      ]
    )
  end

  def assign_billing_thresholds(object)
    billing_thresholds = object.dig(:billing_thresholds)

    self.billing_thresholds_amount_gte = billing_thresholds&.dig(:amount_gte)
    self.billing_thresholds_reset_billing_cycle_anchor = billing_thresholds&.dig(:reset_billing_cycle_anchor)
  end

  def assign_current_phase(object)
    current_phase = object.dig(:current_phase)

    start_date = current_phase&.dig(:start_date)
    self.current_phase_start_date = Time.zone.at(start_date) if start_date

    end_date = current_phase&.dig(:end_date)
    self.current_phase_end_date = Time.zone.at(end_date) if end_date
  end

  def assign_invoice_settings(object)
    invoice_settings = object.dig(:invoice_settings)

    self.invoice_settings_days_until_due = invoice_settings&.dig(:days_until_due)
  end
end
