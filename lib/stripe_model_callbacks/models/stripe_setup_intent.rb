class StripeSetupIntent < StripeModelCallbacks::ApplicationRecord
  belongs_to :stripe_customer, foreign_key: "customer", optional: true, primary_key: "stripe_id"
  belongs_to :stripe_payment_method, foreign_key: "payment_method", optional: true, primary_key: "stripe_id"

  def self.stripe_class
    Stripe::SetupIntent
  end

  def assign_from_stripe(object)
    check_object_is_stripe_class(object)

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self,
      stripe_model: object,
      attributes: %w[
        application cancellation_reason client_secret created customer description flow_directions last_setup_error latest_attempt livemode mandate metadata
        next_action on_behalf_of payment_method payment_method_options payment_method_types single_use_mandate status usage
      ]
    )
  end
end
