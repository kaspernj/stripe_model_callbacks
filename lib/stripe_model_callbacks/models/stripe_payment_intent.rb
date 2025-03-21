class StripePaymentIntent < StripeModelCallbacks::ApplicationRecord
  belongs_to :stripe_customer, foreign_key: "customer", optional: true, primary_key: "stripe_id"
  belongs_to :stripe_latest_charge,
    class_name: "StripeCharge",
    foreign_key: "latest_charge",
    inverse_of: :latest_charge_on_stripe_payment_intent,
    optional: true,
    primary_key: "stripe_id"
  belongs_to :stripe_payment_method, foreign_key: "payment_method", optional: true, primary_key: "stripe_id"

  has_many :stripe_charges, foreign_key: "payment_intent", primary_key: "stripe_id"
  has_many :stripe_refunds, foreign_key: "payment_intent", primary_key: "stripe_id"

  def self.stripe_class
    Stripe::PaymentIntent
  end

  def assign_from_stripe(object)
    check_object_is_stripe_class(object)

    self.metadata = object.metadata

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self,
      stripe_model: object,
      attributes: %w[
        amount
        amount_capturable
        amount_details
        amount_received
        application
        application_fee_amount
        automatic_payment_methods
        canceled_at
        cancellation_reason
        capture_method
        client_secret
        confirmation_method
        created
        currency
        customer
        description
        id
        invoice
        last_payment_error
        latest_charge
        livemode
        next_action
        on_behalf_of
        payment_method
        payment_method_options
        payment_method_types
        processing
        receipt_email
        review
        setup_future_usage
        shipping
        statement_descriptor
        statement_descriptor_suffix
        status
        transfer_data
        transfer_group
      ]
    )
  end

  def amount_money
    Money.new(amount, currency)
  end

  def amount_capturable_money
    Money.new(amount_capturable, currency)
  end

  def amount_received_money
    Money.new(amount_received, currency)
  end

  def cancel(**args)
    updated_payment_intent = Stripe::PaymentIntent.cancel(stripe_id, **args)
    assign_from_stripe(updated_payment_intent)
    save!
  end

  def capture(**args)
    updated_payment_intent = Stripe::PaymentIntent.capture(stripe_id, **args)
    assign_from_stripe(updated_payment_intent)
    save!
  end

  def confirm(**args)
    updated_payment_intent = Stripe::PaymentIntent.confirm(stripe_id, **args)
    assign_from_stripe(updated_payment_intent)
    save!
  end

  def create_stripe_mock!
    mock_payment_intent = Stripe::PaymentIntent.create(
      amount:,
      amount_capturable:,
      amount_details:,
      amount_received:,
      application:,
      application_fee_amount:,
      automatic_payment_methods:,
      canceled_at:,
      cancellation_reason:,
      capture_method:,
      client_secret:,
      currency:,
      customer:,
      id: stripe_id,
      status:
    )
    assign_from_stripe(mock_payment_intent)
    save!
  end
end
