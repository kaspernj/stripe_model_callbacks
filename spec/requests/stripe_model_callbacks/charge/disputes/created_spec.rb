require "rails_helper"

describe "disputes creation" do
  describe "#execute!" do
    it "creates a disppute" do
      expect { mock_stripe_event("charge.dispute.created") }
        .to change(StripeDispute, :count).by(1)

      created_dispute = StripeDispute.last

      expect(response.code).to eq "200"

      expect(created_dispute.stripe_id).to eq "dp_00000000000000"
      expect(created_dispute.created).to eq Time.zone.parse("2018-02-06 13:11:19")
      expect(created_dispute.amount.format).to eq "$10.00"
      expect(created_dispute.balance_transaction_id).to eq "txn_00000000000000"
      expect(created_dispute.stripe_charge_id).to eq "ch_00000000000000"
      expect(created_dispute.currency).to eq "usd"
      expect(created_dispute.evidence_details_due_by).to eq Time.zone.parse("2018-02-25 23:59:59")
      expect(created_dispute.is_charge_refundable).to eq false
      expect(created_dispute.status).to eq "needs_response"
      expect(created_dispute.reason).to eq "general"
    end
  end
end
