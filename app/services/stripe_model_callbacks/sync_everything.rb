class StripeModelCallbacks::SyncEverything < StripeModelCallbacks::BaseService
  def perform
    StripeModelCallbacks::Coupon::SyncAll.execute!
    StripeModelCallbacks::Plan::SyncAll.execute!

    succeed!
  end
end
