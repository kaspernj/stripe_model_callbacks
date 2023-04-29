class StripeModelCallbacks::SyncEverything < StripeModelCallbacks::BaseService
  def perform
    stripe_classes = [Stripe::Customer, Stripe::Coupon, Stripe::Invoice, Stripe::Plan, Stripe::PaymentIntent, Stripe::Subscription]
    stripe_classes.each do |stripe_class|
      stripe_class.list.each do |stripe_object|
        StripeModelCallbacks::SyncFromStripe.execute!(stripe_object: stripe_object)

        if stripe_class == Stripe::Customer
          sync_stripe_objects(Stripe::PaymentMethod.list(customer: stripe_object.id))
        end
      end
    end

    succeed!
  end

  def sync_stripe_objects(stripe_objects)
    stripe_objects.each do |stripe_object|
      StripeModelCallbacks::SyncFromStripe.execute!(stripe_object: stripe_object)
    end
  end
end
