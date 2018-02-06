require "rails_helper"

describe "subscription updating" do
  let!(:stripe_customer) { create :stripe_customer, id: "cus_00000000000000" }
  let!(:stripe_plan) { create :stripe_plan, id: "silver-express-898_00000000000000" }
  let!(:stripe_subscription) { create :stripe_subscription, id: "sub_00000000000000" }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/customer/customer.subscription.updated.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "updates the subscription" do
      post "/stripe-events", params: payload

      stripe_subscription.reload

      expect(response.code).to eq "200"
      expect(stripe_subscription.stripe_customer).to eq stripe_customer
      expect(stripe_subscription.stripe_plan).to eq stripe_plan
      expect(stripe_subscription.current_period_end).to eq Time.zone.at(1_520_191_372)
    end
  end
end
