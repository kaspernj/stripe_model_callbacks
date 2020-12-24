class StripeSubscriptionItem < StripeModelCallbacks::ApplicationRecord
  belongs_to :stripe_plan, optional: true, primary_key: "stripe_id"
  belongs_to :stripe_price, optional: true, primary_key: "stripe_id"
  belongs_to :stripe_subscription, optional: true, primary_key: "stripe_id"

  has_many :stripe_invoice_items, primary_key: "stripe_id"

  def self.stripe_class
    Stripe::SubscriptionItem
  end

  def assign_from_stripe(object)
    check_object_is_stripe_class(object)
    self.stripe_subscription_id = object.subscription if object.respond_to?(:subscription)
    self.stripe_plan_id = object.plan.id if object.try(:plan).respond_to?(:id)

    assign_price_from_stripe(object)

    StripeModelCallbacks::AttributesAssignerService.execute!(
      model: self, stripe_model: object,
      attributes: %w[id created metadata quantity]
    )
  end

  def update_quantity_on_stripe!(new_quantity)
    sub_object = stripe_subscription.to_stripe

    new_items = [{
      id: id,
      plan: stripe_plan_id,
      quantity: new_quantity
    }]

    sub_object.items = new_items
    sub_object.save

    stripe_subscription.reload_from_stripe!
    nil
  end

private

  def assign_price_from_stripe(object)
    # Older versions doesn't support price
    return unless object.try(:price).respond_to?(:id)

    # Make sure price is created
    price = StripePrice.find_by(stripe_id: object.price.id)
    price ||= StripePrice.create_from_stripe!(object.price)

    # Set stripe ID on the subscription item
    self.stripe_price_id = object.price.id
  end
end
