class StripeDiscount < StripeModelCallbacks::ApplicationRecord
  has_many :subscriptions,
    class_name: "StripeSubscription",
    dependent: :restrict_with_error,
    foreign_key: "discount_identifier",
    inverse_of: :discount,
    primary_key: "identifier"

  def assign_from_stripe(object)
    assign_attributes(
      created: Time.zone.at(object.created)
    )
  end
end
