class StripeModelCallbacks::Coupon::SyncAll < StripeModelCallbacks::BaseService
  def execute
    Stripe::Coupon.list.each do |coupon|
      StripeModelCallbacks::SyncFromStripe.execute!(stripe_object: coupon)
    end

    succeed!
  end
end
