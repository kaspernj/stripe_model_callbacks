class StripePlan < StripeModelCallbacks::ApplicationRecord
  self.primary_key = "id"

  has_many :stripe_invoice_items, dependent: :restrict_with_error
  has_many :stripe_subscriptions, dependent: :restrict_with_error

  scope :not_deleted, -> { where(deleted_at: nil) }

  monetize :amount_cents

  def self.stripe_class
    Stripe::Plan
  end

  def assign_from_stripe(object)
    assign_attributes(amount: Money.new(object.amount, object.currency))

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self, stripe_model: object,
      attributes: %w[created currency id interval interval_count livemode metadata name statement_descriptor trial_period_days]
    )
  end
end
