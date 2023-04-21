class StripePaymentIntent < StripeModelCallbacks::ApplicationRecord
  belongs_to :stripe_customer, foreign_key: "customer", optional: true, primary_key: "stripe_id"

  def self.stripe_class
    Stripe::PaymentIntent
  end

  def assign_from_stripe(object)
    check_object_is_stripe_class(object)

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
        metadata
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
end
