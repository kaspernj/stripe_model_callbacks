require "rails_helper"

describe StripeModelCallbacks::Customer::Subscription::UpdatedService do
  let!(:stripe_account) { create :stripe_account, stripe_customer_identifier: "cus_00000000000000" }
  let!(:stripe_plan) { create :stripe_plan, stripe_identifier: "silver-express-898_00000000000000" }
  let!(:stripe_customer_subscription) { create :stripe_customer_subscription, :active, stripe_subscription_identifier: "sub_00000000000000" }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read(Rails.root.join("spec", "fixtures", "stripe_events", "customer_subscription_updated.json")) }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "updates the subscription" do
      post "/stripe-events", params: payload

      stripe_customer_subscription.reload

      expect(response.code).to eq "200"
      expect(stripe_customer_subscription.account).to eq stripe_account
      expect(stripe_customer_subscription.plan).to eq stripe_plan
      expect(stripe_customer_subscription.current_period_end).to eq Time.zone.at(1_520_191_372)
    end
  end
end
