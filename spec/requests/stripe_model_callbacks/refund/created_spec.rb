require "rails_helper"

describe "refund created" do
  let(:stripe_charge) { create :stripe_charge, stripe_id: "ch_3MI7uIIICJxvfdbR0gVMAA5h" }

  describe "#execute!" do
    it "marks the charge as refunded" do
      stripe_charge

      expect { mock_stripe_event("refund.created") }
        .to change(Activity.where(key: "stripe_refund.create"), :count).by(1)
        .and change(StripeRefund, :count).by(1)

      created_refund = StripeRefund.order(:created_at).last

      expect(response).to have_http_status :ok

      expect(created_refund).to have_attributes(
        stripe_id: "re_CGQ7INZZQPOC8U",
        balance_transaction: "txn_CGQ7Sq2yeAIYK4",
        created: Time.zone.parse("2023-02-09 15:53:50"),
        currency: "dkk",
        metadata: "{}",
        reason: nil,
        receipt_number: "1527-1121",
        status: "succeeded"
      )
      expect(created_refund.amount.format).to eq "1.00 kr."
      expect(created_refund.stripe_charge).to eq stripe_charge
    end
  end
end
