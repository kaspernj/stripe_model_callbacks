class StripeSubscriptionSchedulePhasePlan < ApplicationRecord
  MATCHING_STRIPE_ATTRIBUTES = %w[quantity].freeze
  private_constant :MATCHING_STRIPE_ATTRIBUTES

  belongs_to :stripe_subscription_schedule_phase

  has_one :stripe_subscription_schedule, through: :stripe_subscription_schedule_phase

  def assign_from_stripe(object)
    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self,
      stripe_model: object,
      attributes: MATCHING_STRIPE_ATTRIBUTES
    )

    assign_attributes(
      stripe_plan_id: object.plan,
      stripe_price_id: object.price
    )

    assign_billing_thresholds(object)
  end

private

  def assign_billing_thresholds(object)
    billing_thresholds = object.billing_thresholds

    self.billing_thresholds_usage_gte = billing_thresholds&.usage_gte
  end
end
