class StripeSubscription < StripeModelCallbacks::ApplicationRecord
  belongs_to :customer,
    class_name: "StripeCustomer",
    foreign_key: "customer_identifier",
    inverse_of: :subscription,
    optional: true,
    primary_key: "identifier"

  belongs_to :discount,
    class_name: "StripeDiscount",
    foreign_key: "discount_identifier",
    inverse_of: :subscriptions,
    optional: true,
    primary_key: "identifier"

  belongs_to :plan,
    class_name: "StripePlan",
    foreign_key: "plan_identifier",
    inverse_of: :subscriptions,
    optional: true,
    primary_key: "identifier"

  has_many :invoices,
    class_name: "StripeInvoice",
    dependent: :restrict_with_error,
    foreign_key: "subscription_identifier",
    inverse_of: :subscription,
    primary_key: "identifier"

  def assign_from_stripe(object)
    assign_attributes(
      created: Time.zone.at(object.created),
      canceled_at: object.canceled_at ? Time.zone.at(object.canceled_at) : nil,
      customer_identifier: object.customer,
      ended_at: object.ended_at ? Time.zone.at(object.ended_at) : nil,
      identifier: object.id,
      livemode: object.livemode,
      plan_identifier: object.plan.id
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
