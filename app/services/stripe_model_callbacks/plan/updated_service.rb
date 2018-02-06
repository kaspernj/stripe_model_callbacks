class StripeModelCallbacks::Plan::UpdatedService < StripeModelCallbacks::BaseEventService
  def execute!
    plan = StripePlan.find_or_initialize_by(id: object.id)
    plan.assign_from_stripe(object)
    plan.deleted_at ||= Time.zone.now if event.type == "plan.deleted"

    if plan.save
      plan.create_activity :deleted if event.type == "plan.deleted"
      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: plan.errors.full_messages)
    end
  end
end
