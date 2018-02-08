class StripeModelCallbacks::Account::ExternalAccount::UpdatedService < StripeModelCallbacks::BaseEventService
  def execute!
    bank_account = StripeBankAccount.find_or_initialize_by(id: object.id)
    bank_account.assign_from_stripe(object)

    if bank_account.save
      bank_account.create_activity :deleted if event.type == "account.external_account.deleted"
      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: bank_account.errors.full_messages)
    end
  end
end
