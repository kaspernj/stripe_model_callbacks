class StripeModelCallbacks::StripeDiscount < StripeModelCallbacks::ApplicationRecord
  self.table_name = "stripe_discounts"

  has_many :subscriptions,
    class_name: "StripeModelCallbacks::StripeSubscription",
    dependent: :restrict_with_error,
    foreign_key: "discount_identifier",
    inverse_of: :discount,
    primary_key: "identifier"

  def assign_from_stripe(object)
    assign_attributes(
      created_at: Time.zone.at(object.created)
    )
  end
end
