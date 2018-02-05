class StripeModelCallbacks::StripeDiscount < StripeModelCallbacks::ApplicationRecord
  self.table_name = "stripe_discounts"

  def assign_from_stripe(object)
    assign_attributes(
      created_at: Time.zone.at(object.created)
    )
  end
end
