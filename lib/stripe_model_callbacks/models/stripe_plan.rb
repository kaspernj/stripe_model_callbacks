class StripePlan < StripeModelCallbacks::ApplicationRecord
  belongs_to :stripe_product, optional: true, primary_key: "stripe_id"

  has_many :stripe_invoice_items, primary_key: "stripe_id"
  has_many :stripe_subscriptions, primary_key: "stripe_id"
  has_many :stripe_subscription_items, primary_key: "stripe_id"

  scope :not_deleted, -> { where(deleted_at: nil) }

  monetize :amount_cents

  def self.stripe_class
    Stripe::Plan
  end

  def assign_from_stripe(object)
    assign_attributes(amount: Money.new(object.amount, object.currency))
    self.stripe_product_id = object.product if object.respond_to?(:product)

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self, stripe_model: object,
      attributes: %w[
        created currency id interval interval_count livemode metadata nickname statement_descriptor
        trial_period_days
      ]
    )
  end

  def name
    nickname.presence || stripe_product&.name
  end
end
