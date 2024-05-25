class StripeModelCallbacks::Plan::UpdatedService < StripeModelCallbacks::BaseEventService
  def perform
    plan = StripePlan.find_or_initialize_by(stripe_id: object.id)
    plan.assign_from_stripe(object)
    plan.deleted_at ||= Time.zone.now if event.type == "plan.deleted"

    if plan.save
      plan.try(:create_activity, :deleted) if event.type == "plan.deleted"
      succeed!
    else
      fail! plan.errors.full_messages
    end
  end
end
