class StripeModelCallbacks::SyncEverything < StripeModelCallbacks::BaseService
  def execute
    StripeModelCallbacks::Coupon::SyncAll.execute!
    StripeModelCallbacks::Plan::SyncAll.execute!

    succeed!
  end
end
