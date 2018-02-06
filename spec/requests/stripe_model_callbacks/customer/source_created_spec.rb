require "rails_helper"

describe "customer source updated" do
  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/customer/customer.source.created.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "updates the subscription" do
      expect { post "/stripe-events", params: payload }
        .to change(StripeSource, :count).by(1)

      created_source = StripeSource.last

      expect(response.code).to eq "200"

      expect(created_source.identifier).to eq "src_00000000000000"
      expect(created_source.currency).to eq "usd"
      expect(created_source.created).to eq Time.zone.parse("2018-02-06 12:18:52")
      expect(created_source.owner_email).to eq "jenny.rosen@example.com"
    end
  end
end
