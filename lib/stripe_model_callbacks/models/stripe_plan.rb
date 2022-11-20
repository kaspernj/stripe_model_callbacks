class StripePlan < StripeModelCallbacks::ApplicationRecord
  belongs_to :stripe_product, optional: true, primary_key: "stripe_id"

  has_many :stripe_invoice_items, primary_key: "stripe_id"
  has_many :stripe_subscriptions, primary_key: "stripe_id"
  has_many :stripe_subscription_items, primary_key: "stripe_id"
  has_many :stripe_subscription_schedule_phase_plans, primary_key: "stripe_id"

  scope :not_deleted, -> { where(deleted_at: nil) }

  monetize :amount_cents

  def self.stripe_class
    Stripe::Plan
  end

  def assign_from_stripe(object)
    check_object_is_stripe_class(object)
    self.active = object.active == true if object.respond_to?(:active)
    assign_attributes(amount: Money.new(object.amount, object.currency))
    self.stripe_product_id = object.product if object.respond_to?(:product)

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self, stripe_model: object,
      attributes: %w[
        aggregate_usage amount_decimal billing_scheme
        created currency id interval interval_count livemode metadata nickname statement_descriptor
        trial_period_days usage_type
      ]
    )
  end

  def name
    nickname.presence || stripe_product&.name
  end
end
