class StripeInvoice < StripeModelCallbacks::ApplicationRecord
  belongs_to :stripe_customer, optional: true, primary_key: "stripe_id"
  belongs_to :stripe_discount, optional: true
  belongs_to :stripe_subscription, optional: true, primary_key: "stripe_id"

  has_many :stripe_invoice_items, autosave: true, primary_key: "stripe_id"

  monetize :amount_due_cents, allow_nil: true
  monetize :application_fee_amount_cents, allow_nil: true
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
      due_date: object.due_date ? Time.zone.at(object.due_date) : nil,
      period_start: Time.zone.at(object.period_start),
      period_end: Time.zone.at(object.period_end)
    )

    assign_created(object)
    assign_amounts(object)
    assign_status_transitions(object)

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self, stripe_model: object,
      attributes: %w[
        attempted attempt_count billing closed currency description id livemode
        ending_balance forgiven next_payment_attempt number paid receipt_number
        starting_balance statement_descriptor status tax_percent
      ]
    )

    assign_invoice_items(object)
  end

private

  def assign_amounts(object)
    assign_attributes(
      amount_due: Money.new(object.amount_due, object.currency),
      application_fee_amount: object.application_fee_amount ? Money.new(object.application_fee_amount, object.currency) : nil,
      stripe_discount_id: stripe_discount_id_from_object(object),
      subtotal: Money.new(object.subtotal, object.currency),
      tax: object.tax ? Money.new(object.tax, object.currency) : nil,
      total: object.total ? Money.new(object.total, object.currency) : nil
    )
  end

  def assign_created(object)
    # The date-field was renamed to created on 2019-03-14
    if object.respond_to?(:date)
      self.created = Time.zone.at(object.date)
    else
      self.created = Time.zone.at(object.created)
    end
  end

  def assign_invoice_items(object)
    object.lines.each do |item|
      # Has to be found this way to actually update the values
      invoice_item = stripe_invoice_items.find do |invoice_item_i|
        invoice_item_i.stripe_id == item.id &&
          invoice_item_i.stripe_subscription_item_id == item.subscription_item &&
          invoice_item_i.stripe_plan_id == item.plan&.id
      end

      invoice_item ||= stripe_invoice_items.build
      invoice_item.stripe_invoice_id = object.id
      invoice_item&.assign_from_stripe(item)
    end
  end

  def assign_status_transitions(object)
    return unless object.respond_to?(:status_transitions)

    transition_dates = {}
    %i[finalized_at marked_uncollectible_at paid_at voided_at].each do |date_attribute|
      date_value = object.status_transitions.__send__(date_attribute)
      transition_dates[date_attribute] = Time.zone.at(date_value) if date_value.present?
    end

    assign_attributes(transition_dates) if transition_dates.any?
  end

  def stripe_discount_id_from_object(object)
    return nil unless object.discount

    response = StripeModelCallbacks::Customer::DiscountUpdatedService.execute(object: object.discount)
    raise response.errors.join(". ") if response.errors.any?

    response.result.id
  end
end
