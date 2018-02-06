require "rails_helper"

describe "customer source updated" do
  let!(:stripe_source) { create :stripe_source, id: "src_00000000000000" }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/customer/customer.source.updated.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "updates the subscription" do
      expect { post "/stripe-events", params: payload }
        .to change(StripeSource, :count).by(0)

      stripe_source.reload

      expect(response.code).to eq "200"

      expect(stripe_source.id).to eq "src_00000000000000"
      expect(stripe_source.currency).to eq "usd"
      expect(stripe_source.created).to eq Time.zone.parse("2018-02-04 19:29:53")
      expect(stripe_source.owner_email).to eq "jenny.rosen@example.com"
    end
  end
end
