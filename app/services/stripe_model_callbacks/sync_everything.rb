class StripeModelCallbacks::SyncEverything < StripeModelCallbacks::BaseService
  def self.stripe_classes
    [Stripe::Customer, Stripe::Coupon, Stripe::Invoice, Stripe::Plan, Stripe::PaymentIntent, Stripe::Subscription]
  end

  def perform
    StripeModelCallbacks::SyncEverything.stripe_classes.each do |stripe_class|
      stripe_class.list.each do |stripe_object|
        StripeModelCallbacks::SyncFromStripe.execute!(stripe_object:)

        sync_stripe_objects(Stripe::PaymentMethod.list(customer: stripe_object.id)) if stripe_class == Stripe::Customer
      end
    end

    succeed!
  end

  def sync_stripe_objects(stripe_objects)
    stripe_objects.each do |stripe_object|
      StripeModelCallbacks::SyncFromStripe.execute!(stripe_object:)
    end
  end
end
