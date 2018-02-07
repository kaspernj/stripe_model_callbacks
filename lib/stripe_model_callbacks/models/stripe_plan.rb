class StripePlan < StripeModelCallbacks::ApplicationRecord
  self.primary_key = "id"

  belongs_to :stripe_product, optional: true

  has_many :stripe_invoice_items
  has_many :stripe_subscriptions

  scope :not_deleted, -> { where(deleted_at: nil) }

  delegate :name, to: :stripe_product

  monetize :amount_cents

  def self.stripe_class
    Stripe::Plan
  end

  def assign_from_stripe(object)
    assign_attributes(
      amount: Money.new(object.amount, object.currency),
      stripe_product_id: object.product
    )

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self, stripe_model: object,
      attributes: %w[
        created currency id interval interval_count livemode metadata statement_descriptor trial_period_days
      ]
    )
  end
end
