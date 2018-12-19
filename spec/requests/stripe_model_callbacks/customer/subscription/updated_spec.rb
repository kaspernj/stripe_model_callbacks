require "rails_helper"

describe "subscription updating" do
  let!(:stripe_customer) { create :stripe_customer, stripe_id: "cus_00000000000000" }
  let!(:stripe_plan) { create :stripe_plan, stripe_id: "silver-express-898" }
  let!(:stripe_subscription) { create :stripe_subscription, stripe_id: "sub_CGPu5KqP1TORKF" }
  let!(:stripe_subscription_item) do
    create :stripe_subscription_item, stripe_plan: stripe_plan, stripe_subscription: stripe_subscription, stripe_id: "si_CGPuxYgJ7bx2UW"
  end

  describe "#execute!" do
    it "updates the subscription" do
      expect { mock_stripe_event("customer.subscription.updated") }
        .to change(StripeSubscription, :count).by(0)
        .and change(StripeSubscriptionItem, :count).by(0)

      stripe_subscription.reload
      stripe_subscription_item.reload

      expect(response.code).to eq "200"

      expect(stripe_subscription.stripe_customer).to eq stripe_customer
      expect(stripe_subscription.stripe_plan).to eq stripe_plan
      expect(stripe_subscription.current_period_end).to eq Time.zone.at(1_520_191_372)

      expect(stripe_subscription_item.stripe_subscription).to eq stripe_subscription
      expect(stripe_subscription_item.stripe_plan).to eq stripe_plan
    end
  end
end
