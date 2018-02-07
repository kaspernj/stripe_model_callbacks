class StripePlan < StripeModelCallbacks::ApplicationRecord
  self.primary_key = "id"

  belongs_to :stripe_product, optional: true

  has_many :stripe_invoice_items
  has_many :stripe_subscriptions

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
        created currency id interval interval_count livemode metadata statement_descriptor trial_period_days
      ]
    )
  end

  def name
    stripe_product&.name
  end
end
