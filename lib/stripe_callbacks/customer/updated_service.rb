class StripeCallbacks::Customer::UpdatedService < StripeCallbacks::BaseEventService
  def execute!
    account.assign_from_stripe(object)

    if account.save
      ServicePattern::Response.new(success: true)
    else
      ServicePattern::Response.new(errors: account.errors.full_messages)
    end
  end

private

  def account
    @_account ||= Account.find_by!(stripe_customer_identifier: object.id)
  end
end
