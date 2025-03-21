class StripeModelCallbacks::Account::ExternalAccount::UpdatedService < StripeModelCallbacks::BaseEventService
  def perform
    bank_account = StripeBankAccount.find_or_initialize_by(stripe_id: object.id)
    bank_account.assign_from_stripe(object)

    if bank_account.save
      bank_account.create_audit!(action: :deleted) if event.type == "account.external_account.deleted"
      succeed!
    else
      fail! bank_account.errors.full_messages
    end
  end
end
