require "rails_helper"

describe "disputes funds withdrawn" do
  let!(:dispute) { create :stripe_dispute, id: "dp_00000000000000" }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/charge/charge.dispute.funds_withdrawn.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "adds an activity and updates the disppute" do
      expect { PublicActivity.with_tracking { post "/stripe-events", params: payload } }
        .to change(StripeDispute, :count).by(0)
        .and change(PublicActivity::Activity.where(key: "stripe_dispute.funds_withdrawn"), :count).by(1)

      dispute.reload

      expect(response.code).to eq "200"

      expect(dispute.id).to eq "dp_00000000000000"
      expect(dispute.created).to eq Time.zone.parse("2018-02-06 13:12:40")
      expect(dispute.amount.format).to eq "$10.00"
      expect(dispute.balance_transaction_id).to eq "txn_00000000000000"
      expect(dispute.stripe_charge_id).to eq "ch_00000000000000"
      expect(dispute.currency).to eq "usd"
      expect(dispute.evidence_details_due_by).to eq Time.zone.parse("2018-02-25 23:59:59")
      expect(dispute.is_charge_refundable).to eq false
      expect(dispute.status).to eq "needs_response"
      expect(dispute.reason).to eq "general"
    end
  end
end
