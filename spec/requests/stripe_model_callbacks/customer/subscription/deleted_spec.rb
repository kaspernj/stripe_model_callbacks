require "rails_helper"

describe "subscription deletion" do
  let!(:customer) { create :stripe_customer, identifier: "cus_00000000000000" }
  let!(:plan) { create :stripe_plan, identifier: "silver-express-898_00000000000000" }
  let!(:subscription) { create :stripe_subscription, customer: customer, plan: plan, identifier: "sub_00000000000000" }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/customer/customer.subscription.deleted.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "ends the subscription" do
      post "/stripe-events", params: payload

      subscription.reload

      expect(response.code).to eq "200"
      expect(subscription.customer).to eq customer
      expect(subscription.plan).to eq plan
      expect(subscription.ended_at).to eq Time.zone.at(1_517_769_949)
    end
  end
end
