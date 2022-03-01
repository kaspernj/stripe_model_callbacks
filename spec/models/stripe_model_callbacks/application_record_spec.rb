require "rails_helper"

describe StripeModelCallbacks::ApplicationRecord, :stripe_mock do
  let(:stripe_product) { create :stripe_product, :with_stripe_mock }
  let(:subscription) { create :stripe_subscription, :with_stripe_mock }

  describe "#to_stripe" do
    it "returns a Stripe object" do
      expect(subscription.to_stripe).to be_a Stripe::Subscription
    end
  end

  describe "#update_on_stripe" do
    it "updates the data on Stripe" do
      result = subscription.update_on_stripe(tax_percent: 11)

      expect(result).to be true
      expect(subscription.to_stripe.tax_percent).to eq 11
      expect(subscription.tax_percent).to eq 11
    end
  end

  describe "#destroy_on_stripe" do
    it "deletes the object on Stripe" do
      result = subscription.destroy_on_stripe

      expect(result).to be true
      expect(subscription.status).to eq "canceled"
    end
  end

  describe "#create_from_stripe" do
    it "creates a record from a Stripe object" do
      mock_plan = Stripe::Plan.create(amount: 1000, id: "test-plan", currency: "usd", name: "Test plan", interval: "month", product: stripe_product.stripe_id)
      stripe_plan = StripePlan.create_from_stripe!(mock_plan)

      expect(stripe_plan.stripe_id).to eq "test-plan"
      expect(stripe_plan.amount.format).to eq "$10.00"
    end
  end
end
