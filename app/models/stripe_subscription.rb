class StripeSubscription < StripeModelCallbacks::ApplicationRecord
  self.primary_key = "id"

  belongs_to :stripe_customer, inverse_of: :stripe_subscription, optional: true
  belongs_to :stripe_discount, inverse_of: :stripe_subscriptions, optional: true
  belongs_to :stripe_plan, inverse_of: :stripe_subscriptions, optional: true
  has_many :stripe_invoices, dependent: :restrict_with_error, inverse_of: :stripe_subscription
  has_many :stripe_discounts, dependent: :restrict_with_error, inverse_of: :stripe_subscription

  def assign_from_stripe(object)
    assign_attributes(
      created: Time.zone.at(object.created),
      canceled_at: object.canceled_at ? Time.zone.at(object.canceled_at) : nil,
      stripe_customer_id: object.customer,
      ended_at: object.ended_at ? Time.zone.at(object.ended_at) : nil,
      id: object.id,
      livemode: object.livemode,
      stripe_plan_id: object.plan.id
    )

    assign_periods(object)
    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self, stripe_model: object,
      attributes: %w[billing cancel_at_period_end status]
    )
  end

private

  def assign_periods(object)
    assign_attributes(
      current_period_start: Time.zone.at(object.current_period_start),
      current_period_end: Time.zone.at(object.current_period_end),
      start: Time.zone.at(object.start),
      trial_start: object.trial_start ? Time.zone.at(object.trial_start) : nil,
      trial_end: object.trial_end ? Time.zone.at(object.trial_end) : nil
    )
  end
end
