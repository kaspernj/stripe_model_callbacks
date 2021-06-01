class StripeModelCallbacks::Plan::SyncAll < StripeModelCallbacks::BaseService
  def perform
    Stripe::Plan.list.each do |plan|
      StripeModelCallbacks::SyncFromStripe.execute!(stripe_object: plan)
    end

    succeed!
  end
end
