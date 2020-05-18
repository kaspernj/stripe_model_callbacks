class StripeSubscriptionSchedulePhase < ApplicationRecord
  MATCHING_STRIPE_ATTRIBUTES = %w[
    application_fee_percent
    collection_method
    default_payment_method
    prorate
    proration_behavior
  ].freeze
  private_constant :MATCHING_STRIPE_ATTRIBUTES

  belongs_to :stripe_subscription_schedule, primary_key: "stripe_id"

  has_many :stripe_subscription_schedule_phase_plans, dependent: :destroy

  def assign_from_stripe(object)
    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self,
      stripe_model: object,
      attributes: MATCHING_STRIPE_ATTRIBUTES
    )

    assign_billing_thresholds(object)
    assign_invoice_settings(object)
    assign_timestamps(object)

    assign_subscription_schedule_phase_plans(object)
  end

private

  def assign_billing_thresholds(object)
    billing_thresholds = object.billing_thresholds

    self.billing_thresholds_amount_gte = billing_thresholds&.amount_gte
    self.billing_thresholds_reset_billing_cycle_anchor = billing_thresholds&.reset_billing_cycle_anchor
  end

  def assign_invoice_settings(object)
    invoice_settings = object.invoice_settings

    self.invoice_settings_days_until_due = invoice_settings&.days_until_due
  end

  def assign_timestamps(object)
    %i[end_date start_date trial_end].each do |timestamp|
      object_timestamp = object.__send__(timestamp)
      __send__("#{timestamp}=", Time.zone.at(object_timestamp)) if object_timestamp
    end
  end

  def assign_subscription_schedule_phase_plans(object)
    self.stripe_subscription_schedule_phase_plans = new_stripe_subscription_schedule_phase_plans(object)
  end

  def new_stripe_subscription_schedule_phase_plans(object)
    @new_stripe_subscription_schedule_phase_plans ||= object.plans.collect do |plan|
      subscription_schedule_phase_plan = StripeSubscriptionSchedulePhasePlan.new(stripe_subscription_schedule_phase: self)
      subscription_schedule_phase_plan.assign_from_stripe(plan)
      subscription_schedule_phase_plan
    end
  end
end
