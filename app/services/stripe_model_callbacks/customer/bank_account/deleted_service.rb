class StripeModelCallbacks::Customer::BankAccount::DeletedService < StripeModelCallbacks::BaseEventService
  def execute!
    bank_account = StripeBankAccount.find_or_initialize_by(stripe_id: object.id)
    bank_account.assign_from_stripe(object)

    if bank_account.save
      bank_account.create_activity :customer_bank_account_deleted if event.type == "customer.bank_account.deleted"
      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: bank_account.errors.full_messages)
    end
  end
end
