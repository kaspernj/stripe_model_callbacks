class StripeSubscription < StripeModelCallbacks::ApplicationRecord
  self.primary_key = "id"

  belongs_to :stripe_customer, optional: true
  belongs_to :stripe_discount, optional: true
  belongs_to :stripe_plan, optional: true
  has_many :stripe_invoices
  has_many :stripe_discounts
  has_many :stripe_subscription_items, autosave: true

  STATES = %w[trialing active past_due canceled unpaid].freeze

  scope :with_state, lambda { |states|
    response = StripeModelCallbacks::Subscription::StateCheckerService.execute!(allowed: STATES, state: states)
    raise response.errors.join(".") unless response.success?
    where(status: states)
  }

  def self.stripe_class
    Stripe::Subscription
  end

  def assign_from_stripe(object)
    assign_attributes(
      canceled_at: object.canceled_at ? Time.zone.at(object.canceled_at) : nil,
      stripe_customer_id: object.customer,
      ended_at: object.ended_at ? Time.zone.at(object.ended_at) : nil,
      stripe_plan_id: object.plan&.id
    )

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
        id: item.id,
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

  def assign_items(object)
    object.items.each do |item|
      if new_record?
        sub_item = stripe_subscription_items.build
      elsif item.respond_to?(:id)
        # Has to be found this way to actually update the values
        sub_item = stripe_subscription_items.find { |sub_item_i| sub_item_i.id == item.id }
      end

      sub_item&.assign_from_stripe(item)
    end
  end

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
