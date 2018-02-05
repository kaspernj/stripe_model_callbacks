require "rails_helper"

describe "refund updated" do
  let!(:charge) { create :stripe_charge, identifier: "ch_00000000000000" }
  let!(:refund) { create :stripe_refund, identifier: "re_00000000000000", charge: charge }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/charge_refund_updated.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "creates the subscription" do
      expect { post "/stripe-events", params: payload }
        .to change(StripeModelCallbacks::StripeRefund, :count).by(0)

      refund.reload

      expect(response.code).to eq "200"
      expect(refund.charge).to eq charge
      expect(refund.amount.format).to eq "$1.00"
      expect(refund.balance_transaction).to eq nil
      expect(refund.created_at).to eq Time.zone.parse("2018-02-05 16:37:07")
      expect(refund.currency).to eq "usd"
      expect(refund.metadata).to eq "{}"
      expect(refund.reason).to eq nil
      expect(refund.receipt_number).to eq nil
      expect(refund.status).to eq "succeeded"
    end
  end
end
