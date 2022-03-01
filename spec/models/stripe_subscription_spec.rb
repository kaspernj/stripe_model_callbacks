require "rails_helper"

describe StripeSubscription, :stripe_mock do
  let(:subscription) { create :stripe_subscription, :active, :with_stripe_mock }
  let(:subscription_cancel_at_period_end) { create :stripe_subscription, :cancel_at_period_end, :with_stripe_mock }

  describe "#cancel!" do
    it "cancels the subscription" do
      subscription.cancel!

      expect(subscription.cancel_at_period_end?).to be false
      expect(subscription.canceled_at).to be > 10.seconds.ago
      expect(subscription.status).to eq "canceled"
    end

    it "cancels the subscription at the period end" do
      subscription.cancel!(at_period_end: true)

      expect(subscription.cancel_at_period_end?).to be true
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

  describe "#stripe_plan" do
    let(:plan) { create :stripe_plan, stripe_id: "plan_123" }
    let(:subscription) { create :stripe_subscription, stripe_plan_id: "plan_123" }
    let(:subscription_item) { create :stripe_subscription_item, stripe_plan_id: "plan_123", stripe_subscription_id: "sub_321" }

    it "returns the plan for the subscription" do
      plan
      expect(subscription.stripe_plan).to eq plan
    end
  end

  describe "#stripe_plans" do
    let(:plan) { create :stripe_plan, stripe_id: "plan_123" }
    let(:subscription) { create :stripe_subscription, stripe_id: "sub_321" }
    let(:subscription_item) { create :stripe_subscription_item, stripe_plan_id: "plan_123", stripe_subscription_id: "sub_321" }

    it "returns the plan for the subscription" do
      subscription_item
      expect(subscription.stripe_plans).to eq [plan]
    end
  end

  describe "#with_state" do
    it "finds the right subscriptions" do
      subscriptions = StripeSubscription.with_state(:active)
      expect(subscriptions).to eq [subscription]
    end

    it "raises an error if given an invalid state" do
      expect { StripeSubscription.with_state(:invalid_state) }
        .to raise_error(ServicePattern::FailedError, "Not allowed: invalid_state")
    end
  end
end
