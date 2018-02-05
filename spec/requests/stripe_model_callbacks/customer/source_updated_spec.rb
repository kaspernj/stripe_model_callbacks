require "rails_helper"

describe "customer source updated" do
  let!(:stripe_customer) { create :stripe_customer, identifier: "cus_00000000000000" }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/customer_source_updated.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "updates the subscription" do
      expect { post "/stripe-events", params: payload }
        .to change(StripeModelCallbacks::StripeSource, :count).by(1)

      created_source = StripeModelCallbacks::StripeSource.last

      expect(response.code).to eq "200"
      expect(created_source.currency).to eq "usd"
    end
  end
end
