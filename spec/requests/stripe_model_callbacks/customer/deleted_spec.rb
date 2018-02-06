require "rails_helper"

describe "customer deleted" do
  let!(:stripe_customer) { create :stripe_customer, identifier: "cus_00000000000000" }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/customer/customer.deleted.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "updates the subscription" do
      post "/stripe-events", params: payload

      stripe_customer.reload

      expect(response.code).to eq "200"
      expect(stripe_customer.deleted_at).to be > 1.minute.ago
    end
  end
end
