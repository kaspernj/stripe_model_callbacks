require "rails_helper"

describe "refund updated" do
  let!(:charge) { create :stripe_charge, stripe_id: "ch_00000000000000" }
  let!(:refund) { create :stripe_refund, stripe_id: "re_00000000000000", stripe_charge: charge }

  describe "#execute!" do
    it "creates the subscription" do
      expect { mock_stripe_event("charge.refund.updated") }
        .to change(StripeRefund, :count).by(0)

      refund.reload

      expect(response.code).to eq "200"
      expect(refund.stripe_charge).to eq charge
      expect(refund.amount.format).to eq "$1.00"
      expect(refund.balance_transaction).to eq nil
      expect(refund.created).to eq Time.zone.parse("2018-02-05 16:37:07")
      expect(refund.currency).to eq "usd"
      expect(refund.metadata).to eq "{}"
      expect(refund.reason).to eq nil
      expect(refund.receipt_number).to eq nil
      expect(refund.status).to eq "succeeded"
    end
  end
end
