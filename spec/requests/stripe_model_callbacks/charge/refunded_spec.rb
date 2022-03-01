require "rails_helper"

describe "charge refunded" do
  let!(:charge) { create :stripe_charge, stripe_id: "ch_1BrtHZAT5SYrvIfdqkyvLyvX" }

  describe "#execute!" do
    it "marks the charge as refunded" do
      expect { PublicActivity.with_tracking { mock_stripe_event("charge.refunded") } }
        .to change(PublicActivity::Activity.where(key: "stripe_charge.refunded"), :count).by(1)
        .and change(StripeCharge, :count).by(1)
        .and change(StripeRefund, :count).by(1)

      created_charge = StripeCharge.order(:created_at).last
      created_refund = StripeRefund.last

      expect(response.code).to eq "200"

      expect(created_charge.amount.format).to eq "$1.00"
      expect(created_charge.amount_refunded.format).to eq "$1.00"
      expect(created_charge.description).to eq "My First Test Charge (created for API docs)"
      expect(created_charge.refunded?).to be true

      expect(created_refund.stripe_id).to eq "re_CGQ7INZZQPOC8U"
      expect(created_refund.amount.format).to eq "$1.00"
      expect(created_refund.balance_transaction).to eq "txn_CGQ7Sq2yeAIYK4"
      expect(created_refund.stripe_charge).to eq charge
      expect(created_refund.created).to eq Time.zone.parse("2018-02-04 19:36:09")
      expect(created_refund.currency).to eq "usd"
      expect(created_refund.metadata).to eq "{}"
      expect(created_refund.reason).to be_nil
      expect(created_refund.receipt_number).to eq "1527-1121"
      expect(created_refund.status).to eq "succeeded"
    end
  end
end
