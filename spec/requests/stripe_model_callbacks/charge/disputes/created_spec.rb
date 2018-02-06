require "rails_helper"

describe "disputes creation" do
  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/charge/charge.dispute.created.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "creates a disppute" do
      expect { post "/stripe-events", params: payload }
        .to change(StripeDispute, :count).by(1)

      created_dispute = StripeDispute.last

      expect(response.code).to eq "200"

      expect(created_dispute.id).to eq "dp_00000000000000"
      expect(created_dispute.created).to eq Time.zone.parse("2018-02-06 13:11:19")
      expect(created_dispute.amount.format).to eq "$10.00"
      expect(created_dispute.balance_transaction_id).to eq "txn_00000000000000"
      expect(created_dispute.charge_id).to eq "ch_00000000000000"
      expect(created_dispute.currency).to eq "usd"
      expect(created_dispute.evidence_details_due_by).to eq Time.zone.parse("2018-02-25 23:59:59")
      expect(created_dispute.is_charge_refundable).to eq false
      expect(created_dispute.status).to eq "needs_response"
      expect(created_dispute.reason).to eq "general"
    end
  end
end
