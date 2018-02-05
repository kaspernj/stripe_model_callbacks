require "rails_helper"

describe StripeModelCallbacks::Charge::RefundedService do
  let!(:charge) { create :stripe_charge, identifier: "ch_00000000000000" }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/charge_refunded.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "marks the charge as refunded" do
      post "/stripe-events", params: payload

      charge.reload

      expect(response.code).to eq "200"
      expect(charge.refunded?).to eq true
      expect(charge.amount_refunded).to eq Money.new(100, "USD")
    end
  end
end
