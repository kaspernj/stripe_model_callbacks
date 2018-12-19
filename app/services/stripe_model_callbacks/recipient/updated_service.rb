class StripeModelCallbacks::Recipient::UpdatedService < StripeModelCallbacks::BaseEventService
  def execute!
    recipient = StripeRecipient.find_or_initialize_by(stripe_id: object.id)
    recipient.assign_from_stripe(object)
    recipient.deleted_at ||= Time.zone.now if event.type == "recipient.deleted"

    if recipient.save
      recipient.create_activity :deleted if event.type == "recipient.deleted"
      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: recipient.errors.full_messages)
    end
  end
end
