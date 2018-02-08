require "rails_helper"

describe StripeSubscription, :stripe_mock do
  let(:subscription) { create :stripe_subscription, :active, :with_stripe_mock }
  let(:subscription_cancel_at_period_end) { create :stripe_subscription, :cancel_at_period_end, :with_stripe_mock }

  describe "#cancel!" do
    it "cancels the subscription" do
      subscription.cancel!

      expect(subscription.cancel_at_period_end?).to eq false
      expect(subscription.canceled_at).to be > 10.seconds.ago
      expect(subscription.status).to eq "canceled"
    end

    it "cancels the subscription at the period end" do
      subscription.cancel!(at_period_end: true)

      expect(subscription.cancel_at_period_end?).to eq true
      expect(subscription.canceled_at).to be > 10.seconds.ago
      expect(subscription.status).to eq "active"
    end
  end

  describe "#reactivate!" do
    it "reactivates a subscription" do
      # Currently Stripe mock doesnt work with nested plans, so this cant be tested properly
      expect(subscription_cancel_at_period_end.to_stripe).to receive(:save)
      subscription_cancel_at_period_end.reactivate!
    end
  end
end
