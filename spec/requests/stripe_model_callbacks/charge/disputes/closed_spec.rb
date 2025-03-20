require "rails_helper"

describe "disputes closed" do
  let!(:dispute) { create :stripe_dispute, stripe_id: "dp_00000000000000" }

  describe "#execute!" do
    it "adds an activity and updates the disppute" do
      expect { mock_stripe_event("charge.dispute.closed") }
        .to change(StripeDispute, :count).by(0)
        .and change(ActiveRecordAuditable::Audit.where_type("StripeDispute").where_action("closed"), :count).by(1)

      dispute.reload

      expect(response).to have_http_status :ok

      expect(dispute.stripe_id).to eq "dp_00000000000000"
      expect(dispute.created).to eq Time.zone.parse("2018-02-06 13:11:54")
      expect(dispute.amount.format).to eq "$10.00"
      expect(dispute.balance_transaction_id).to eq "txn_00000000000000"
      expect(dispute.stripe_charge_id).to eq "ch_00000000000000"
      expect(dispute.currency).to eq "usd"
      expect(dispute.evidence_details_due_by).to eq Time.zone.parse("2018-02-25 23:59:59")
      expect(dispute.is_charge_refundable).to be false
      expect(dispute.status).to eq "won"
      expect(dispute.reason).to eq "general"
    end
  end
end
