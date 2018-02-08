class StripeInvoice < StripeModelCallbacks::ApplicationRecord
  self.primary_key = "id"

  belongs_to :stripe_customer, optional: true
  belongs_to :stripe_subscription, optional: true
  has_many :stripe_invoice_items

  monetize :amount_due_cents, allow_nil: true
  monetize :application_fee_cents, allow_nil: true
  monetize :discount_cents, allow_nil: true
  monetize :subtotal_cents, allow_nil: true
  monetize :tax_cents, allow_nil: true
  monetize :total_cents, allow_nil: true

  def self.stripe_class
    Stripe::Invoice
  end

  def assign_from_stripe(object)
    assign_attributes(
      stripe_charge_id: object.charge,
      stripe_customer_id: object.customer,
      stripe_subscription_id: object.subscription,
      date: Time.zone.at(object.date),
      due_date: object.due_date ? Time.zone.at(object.due_date) : nil,
      period_start: Time.zone.at(object.period_start),
      period_end: Time.zone.at(object.period_end)
    )

    assign_amounts(object)

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self, stripe_model: object,
      attributes: %w[
        attempted attempt_count billing closed currency description forgiven id livemode
        ending_balance forgiven next_payment_attempt number paid receipt_number
        starting_balance statement_descriptor tax_percent
      ]
    )
  end

private

  def assign_amounts(object)
    assign_attributes(
      amount_due: Money.new(object.amount_due, object.currency),
      application_fee: object.application_fee ? Money.new(object.application_fee, object.currency) : nil,
      discount: object.discount ? Money.new(object.discount, object.currency) : nil,
      subtotal: Money.new(object.subtotal, object.currency),
      tax: object.tax ? Money.new(object.tax, object.currency) : nil,
      total: object.total ? Money.new(object.total, object.currency) : nil
    )
  end
end
