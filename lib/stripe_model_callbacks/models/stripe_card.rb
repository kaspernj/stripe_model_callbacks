class StripeCard < StripeModelCallbacks::ApplicationRecord
  self.primary_key = "id"

  belongs_to :stripe_customer, optional: true

  def self.stripe_class
    StripeClass
  end

  def assign_from_stripe(object)
    self.stripe_customer_id = object.customer

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self, stripe_model: object,
      attributes: %w[
        id address_city address_country address_line1 address_line1_check
        address_line2 address_state address_zip address_zip_check brand
        country cvc_check dynamic_last4 exp_month exp_year fingerprint
        funding last4 name tokenization_method
      ]
    )
  end
end
