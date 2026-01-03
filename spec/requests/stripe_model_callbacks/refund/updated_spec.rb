require "rails_helper"

describe "refund updated" do
  let!(:charge) { create :stripe_charge, stripe_id: "ch_00000000000000" }
  let!(:refund) { create :stripe_refund, stripe_id: "re_00000000000000", stripe_charge: charge }

  describe "#execute!" do
    it "creates the subscription" do
      expect { mock_stripe_event("charge.refund.updated") }
        .to change(StripeRefund, :count).by(0)

      refund.reload

      expect(response).to have_http_status :ok
      expect(refund).to have_attributes(
        stripe_charge_id: charge.stripe_id,
        balance_transaction: nil,
        created: Time.zone.parse("2018-02-05 16:37:07"),
        currency: "usd",
        metadata: "{}",
        reason: nil,
        receipt_number: nil,
        status: "succeeded"
      )
      expect(refund.amount.format).to eq "$1.00"
    end
  end
end
