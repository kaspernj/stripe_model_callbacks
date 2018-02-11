class StripeInvoiceItem < StripeModelCallbacks::ApplicationRecord
  self.primary_key = "id"

  belongs_to :stripe_customer, optional: true
  belongs_to :stripe_invoice, optional: true
  belongs_to :stripe_plan, optional: true

  monetize :amount_cents

  def self.stripe_class
    Stripe::InvoiceItem
  end

  def assign_from_stripe(object)
    assign_attributes(
      amount: Money.new(object.amount, object.currency),
      stripe_customer_id: object.try(:customer),
      metadata: JSON.generate(object.metadata),
      period_start: Time.zone.at(object.period.start),
      period_end: Time.zone.at(object.period.end),
      stripe_plan_id: object.plan&.id,
      stripe_subscription_id: object.subscription,
    )

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self, stripe_model: object,
      attributes: %w[
        currency description discountable id livemode proration quantity subscription_item
      ]
    )
  end
end
