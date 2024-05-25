class StripeModelCallbacks::Review::UpdatedService < StripeModelCallbacks::BaseEventService
  def perform
    review = StripeReview.find_or_initialize_by(stripe_id: object.id)
    review.assign_from_stripe(object)

    if review.save
      review.try(:create_activity, :closed) if event.type == "review.closed"
      succeed!
    else
      fail! review.errors.full_messages
    end
  end
end
