class StripeCustomer < StripeModelCallbacks::ApplicationRecord
  has_many :stripe_cards, primary_key: "stripe_id"
  has_many :stripe_charges, primary_key: "stripe_id"
  has_many :stripe_discounts, primary_key: "stripe_id"
  has_many :stripe_invoices, primary_key: "stripe_id"
  has_many :stripe_invoice_items, primary_key: "stripe_id"
  has_many :stripe_orders, primary_key: "stripe_id"
  has_many :stripe_payment_intents, foreign_key: "customer", primary_key: "stripe_id"
  has_many :stripe_payment_methods, foreign_key: "customer", primary_key: "stripe_id"
  has_many :stripe_setup_intents, foreign_key: "customer", primary_key: "stripe_id"
  has_many :stripe_subscriptions, primary_key: "stripe_id"
  has_many :stripe_subscription_schedules, primary_key: "stripe_id"

  def self.stripe_class
    Stripe::Customer
  end

  def assign_from_stripe(object)
    check_object_is_stripe_class(object)

    if object.respond_to?(:account_balance)
      self.balance = object.account_balance
    elsif object.respond_to?(:balance)
      self.balance = object.balance
    else
      Rails.logger.error "Couldn't figure out where to get the customers balance from"
    end

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self, stripe_model: object,
      attributes: %w[
        currency created default_source delinquent description discount email
        id livemode metadata
      ]
    )
  end

  def create_stripe_mock!
    mock_customer = Stripe::Customer.create(
      id: stripe_id,
      source: StripeMock.create_test_helper.generate_card_token
    )
    assign_from_stripe(mock_customer)
    save!
  end
end
