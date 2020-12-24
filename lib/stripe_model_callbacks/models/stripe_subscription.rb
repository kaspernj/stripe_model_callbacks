class StripeSubscription < StripeModelCallbacks::ApplicationRecord
  belongs_to :stripe_customer, optional: true, primary_key: "stripe_id"
  belongs_to :stripe_discount, optional: true
  belongs_to :stripe_plan, optional: true, primary_key: "stripe_id"
  has_many :stripe_invoices, primary_key: "stripe_id"
  has_many :stripe_discounts, primary_key: "stripe_id"
  has_many :stripe_subscription_default_tax_rates, dependent: :destroy
  has_many :stripe_subscription_items, autosave: true, primary_key: "stripe_id"
  has_many :stripe_subscription_schedules, primary_key: "stripe_id"
  has_many :stripe_plans, through: :stripe_subscription_items
  has_many :stripe_tax_rates

  STATES = %w[trialing active past_due canceled unpaid].freeze

  scope :with_state, lambda { |states|
    StripeModelCallbacks::Subscription::StateCheckerService.execute!(allowed: STATES, state: states)
    where(status: states)
  }

  def self.stripe_class
    Stripe::Subscription
  end

  def assign_from_stripe(object)
    check_object_is_stripe_class(object)
    assign_attributes(
      canceled_at: object.canceled_at ? Time.zone.at(object.canceled_at) : nil,
      ended_at: object.ended_at ? Time.zone.at(object.ended_at) : nil,
      latest_stripe_invoice_id: latest_invoice_id(object),
      stripe_customer_id: object.customer,
      stripe_plan_id: object.respond_to?(:plan) ? object.plan&.id : nil
    )

    assign_discount(object)
    assign_items(object)
    assign_periods(object)

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self, stripe_model: object,
      attributes: %w[billing cancel_at_period_end created id livemode status tax_percent]
    )
  end

  def reactivate!
    raise "Cannot reactivate unless cancel at period end has been set" unless cancel_at_period_end?

    # https://stripe.com/docs/subscriptions/canceling-pausing
    items = []
    stripe_subscription_items.each do |item|
      items << {
        id: item.stripe_id,
        plan: item.stripe_plan_id,
        quantity: item.quantity
      }
    end

    to_stripe.items = items
    to_stripe.save

    reload_from_stripe!
    self
  end

  def cancel!(args = {})
    to_stripe.delete(args)
    reload_from_stripe!
    self
  end

private

  def assign_discount(object)
    return if object.discount.blank?

    discount = stripe_discount || build_stripe_discount
    discount.assign_from_stripe(object.discount)
  end

  def assign_items(object)
    object.items.each do |item|
      sub_item = find_item_by_stripe_item(item) if persisted?
      sub_item ||= stripe_subscription_items.build
      sub_item.assign_from_stripe(item)
      sub_item.save! if persisted?
    end
  end

  def assign_periods(object)
    start_date = if object.respond_to?(:start_date)
      object.start_date
    else
      object.start
    end

    assign_attributes(
      current_period_start: Time.zone.at(object.current_period_start),
      current_period_end: Time.zone.at(object.current_period_end),
      start_date: Time.zone.at(start_date),
      trial_start: object.trial_start ? Time.zone.at(object.trial_start) : nil,
      trial_end: object.trial_end ? Time.zone.at(object.trial_end) : nil
    )
  end

  def find_item_by_stripe_item(item)
    stripe_subscription_items.find do |sub_item|
      if item.plan.is_a?(String)
        sub_item.stripe_plan_id == item.plan
      else
        sub_item.stripe_plan_id == item.plan.id
      end
    end
  end

  def latest_invoice_id(object)
    return unless object.respond_to?(:latest_invoice)
    return object.latest_invoice if object.latest_invoice.is_a?(String)

    object.latest_invoice&.id
  end
end
