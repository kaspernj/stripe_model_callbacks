require "rails_helper"

describe "recipient created" do
  let!(:recipient) { create :stripe_recipient, id: "rp_00000000000000" }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/recipient/recipient.updated.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "updates the subscription" do
      expect { post "/stripe-events", params: payload }
        .to change(StripeRecipient, :count).by(0)

      recipient.reload

      expect(response.code).to eq "200"

      expect(recipient.id).to eq "rp_00000000000000"
      expect(recipient.description).to eq "Recipient for John Doe"
      expect(recipient.email).to eq "test@example.com"
      expect(recipient.name).to eq "John Doe"
      expect(recipient.stripe_type).to eq "individual"
    end
  end
end
