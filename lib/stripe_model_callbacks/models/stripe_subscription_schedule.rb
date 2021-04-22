class StripeSubscriptionSchedule < StripeModelCallbacks::ApplicationRecord
  MATCHING_STRIPE_ATTRIBUTES = %w[
    billing created collection_method
    default_payment_method default_source
    end_behavior id metadata livemode
    renewal_behavior renewal_interval
    status
  ].freeze
  private_constant :MATCHING_STRIPE_ATTRIBUTES

  belongs_to :stripe_customer, optional: true, primary_key: "stripe_id"
  belongs_to :stripe_subscription, optional: true, primary_key: "stripe_id"

  has_many :stripe_subscription_schedule_phases, primary_key: "stripe_id", dependent: :destroy

  def self.stripe_class
    Stripe::SubscriptionSchedule
  end

  def assign_from_stripe(object)
    check_object_is_stripe_class(object)
    assign_attributes(
      released_stripe_subscription_id: object.released_subscription,
      stripe_customer_id: object.customer,
      stripe_subscription_id: object.subscription
    )

    assign_billing_thresholds(object)
    assign_current_phase(object)
    assign_invoice_settings(object)
    assign_timestamps(object)

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self,
      stripe_model: object,
      attributes: MATCHING_STRIPE_ATTRIBUTES
    )

    assign_subscription_schedule_phases(object)
  end

  def cancel_on_stripe
    to_stripe.cancel
    update!(canceled_at: Time.zone.now) if respond_to?(:canceled_at)
    reload_from_stripe!
    true
  end

  def cancel_on_stripe!
    raise ActiveRecord::RecordInvalid, self unless cancel_on_stripe
  end

private

  def assign_billing_thresholds(object)
    billing_thresholds = object.billing_thresholds

    self.billing_thresholds_amount_gte = billing_thresholds&.amount_gte
    self.billing_thresholds_reset_billing_cycle_anchor = billing_thresholds&.reset_billing_cycle_anchor
  end

  def assign_current_phase(object)
    current_phase = object.current_phase

    start_date = current_phase&.start_date
    self.current_phase_start_date = Time.zone.at(start_date) if start_date

    end_date = current_phase&.end_date
    self.current_phase_end_date = Time.zone.at(end_date) if end_date
  end

  def assign_invoice_settings(object)
    self.invoice_settings_days_until_due = object.invoice_settings&.days_until_due
  end

  def assign_timestamps(object)
    %i[canceled_at completed_at released_at].each do |timestamp|
      object_timestamp = object.__send__(timestamp)
      __send__("#{timestamp}=", Time.zone.at(object_timestamp)) if object_timestamp
    end
  end

  def assign_subscription_schedule_phases(object)
    self.stripe_subscription_schedule_phases = new_stripe_subscription_schedule_phases(object)
  end

  def new_stripe_subscription_schedule_phases(object)
    @new_stripe_subscription_schedule_phases ||= object.phases.collect do |phase|
      subscription_schedule_phase = StripeSubscriptionSchedulePhase.new(stripe_subscription_schedule: self)
      subscription_schedule_phase.assign_from_stripe(phase)
      subscription_schedule_phase
    end
  end
end
