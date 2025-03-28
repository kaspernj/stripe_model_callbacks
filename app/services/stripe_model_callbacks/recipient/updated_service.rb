class StripeModelCallbacks::Recipient::UpdatedService < StripeModelCallbacks::BaseEventService
  def perform
    recipient = StripeRecipient.find_or_initialize_by(stripe_id: object.id)
    recipient.assign_from_stripe(object)
    recipient.deleted_at ||= Time.zone.now if event.type == "recipient.deleted"

    if recipient.save
      recipient.create_audit!(action: :deleted) if event.type == "recipient.deleted"
      succeed!
    else
      fail! recipient.errors.full_messages
    end
  end
end
