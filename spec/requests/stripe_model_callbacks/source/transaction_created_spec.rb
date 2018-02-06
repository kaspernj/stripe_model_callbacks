require "rails_helper"

describe "source transaction created" do
  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/source/source.transaction_created.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    xit "creates a new transaction" do
      expect { post "/stripe-events", params: payload }
        .to change(StripeSource, :count).by(0)

      source.reload

      expect(response.code).to eq "200"

      # Write more specs
    end
  end
end
