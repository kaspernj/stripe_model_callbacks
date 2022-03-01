require "rails_helper"

describe "disputes updated" do
  let!(:dispute) { create :stripe_dispute, stripe_id: "dp_00000000000000" }

  describe "#execute!" do
    it "updates an existing disppute" do
      expect { mock_stripe_event("charge.dispute.updated") }
        .to change(StripeDispute, :count).by(0)

      dispute.reload

      expect(response.code).to eq "200"

      expect(dispute.stripe_id).to eq "dp_00000000000000"
      expect(dispute.created).to eq Time.zone.parse("2018-02-06 13:12:56")
      expect(dispute.amount.format).to eq "$10.00"
      expect(dispute.balance_transaction_id).to eq "txn_00000000000000"
      expect(dispute.stripe_charge_id).to eq "ch_00000000000000"
      expect(dispute.currency).to eq "usd"
      expect(dispute.evidence_details_due_by).to eq Time.zone.parse("2018-02-25 23:59:59")
      expect(dispute.is_charge_refundable).to be false
      expect(dispute.status).to eq "under_review"
      expect(dispute.reason).to eq "general"
    end
  end
end
