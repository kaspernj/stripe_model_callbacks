require "rails_helper"

describe "charge refunded" do
  let!(:charge) { create :stripe_charge, stripe_id: "ch_1BrtHZAT5SYrvIfdqkyvLyvX" }

  describe "#execute!" do
    it "marks the charge as refunded" do
      expect { PublicActivity.with_tracking { mock_stripe_event("charge.refunded") } }
        .to change(PublicActivity::Activity.where(key: "stripe_charge.refunded"), :count).by(1)
        .and change(StripeCharge, :count).by(1)
        .and change(StripeRefund, :count).by(0)

      created_charge = StripeCharge.order(:created_at).last

      expect(response.code).to eq "200"

      expect(created_charge.amount.format).to eq "$1.00"
      expect(created_charge.amount_captured.format).to eq "$1.00"
      expect(created_charge.amount_refunded.format).to eq "$1.00"
      expect(created_charge).to have_attributes(
        description: "My First Test Charge (created for API docs)",
        refunded: true
      )
    end
  end
end
