require "rails_helper"

describe "recipient created" do
  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/recipient_created.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "creates the subscription" do
      expect { post "/stripe-events", params: payload }
        .to change(StripeModelCallbacks::StripeRecipient, :count).by(1)

      created_recipient = StripeModelCallbacks::StripeRecipient.last

      expect(response.code).to eq "200"

      expect(created_recipient.identifier).to eq "rp_00000000000000"
      expect(created_recipient.description).to eq "Recipient for John Doe"
      expect(created_recipient.email).to eq "test@example.com"
      expect(created_recipient.name).to eq "John Doe"
      expect(created_recipient.stripe_type).to eq "individual"
    end
  end
end
