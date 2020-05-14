class StripeModelCallbacks::Invoice::UpdatedService < StripeModelCallbacks::BaseEventService
  TRACKED_ACTIVITIES = {
    "invoice.payment_failed": :payment_failed,
    "invoice.payment_succeeded": :payment_succeeded,
    "invoice.sent": :sent,
    "invoice.upcoming": :upcoming
  }.freeze.with_indifferent_access
  private_constant :TRACKED_ACTIVITIES

  def execute
    invoice.assign_from_stripe(object)
    return success_actions if invoice.save

    fail!(invoice.errors.full_messages)
  rescue ActiveRecord::RecordNotUnique, PG::UniqueViolation, SQLite3::ConstraintException => e
    # We expect that data of invoice.created is outdated . As invoice does already exist - due too the
    # https://stripe.com/docs/webhooks/best-practices#event-ordering
    return succeed! if event.type == "invoice.created"

    raise e
  end

private

  def success_actions
    create_activity
    succeed!
  end

  def create_activity
    invoice.create_activity(tracked_activities[event.type]) if tracked_activities.fetch(event.type, nil)
  end

  def tracked_activities
    TRACKED_ACTIVITIES
  end

  def invoice
    @invoice ||= StripeInvoice.find_or_initialize_by(stripe_id: object.id)
  end
end
