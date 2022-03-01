require "rails_helper"

describe "payout canceled" do
  let!(:payout) { create :stripe_payout, stripe_id: "po_00000000000000" }

  describe "#execute!" do
    it "adds an activity and updates the payout" do
      expect { mock_stripe_event("payout.canceled") }
        .to change(StripePayout, :count).by(0)
        .and change(PublicActivity::Activity.where(key: "stripe_payout.canceled"), :count).by(1)

      payout.reload

      expect(response.code).to eq "200"

      expect(payout.stripe_id).to eq "po_00000000000000"
      expect(payout.amount.format).to eq "$11.00"
      expect(payout.arrival_date).to eq Time.zone.parse("2018-02-06 11:56:30")
      expect(payout.automatic).to be true
      expect(payout.balance_transaction).to eq "txn_00000000000000"
      expect(payout.created).to eq Time.zone.parse("2018-02-06 11:56:30")
      expect(payout.currency).to eq "usd"
      expect(payout.description).to eq "STRIPE TRANSFER"
      expect(payout.destination).to eq "ba_1BsV3qAT5SYrvIfdnujA67t8"
      expect(payout.failure_balance_transaction).to be_nil
      expect(payout.failure_code).to be_nil
      expect(payout.failure_message).to be_nil
      expect(payout.livemode).to be false
      expect(payout.metadata).to eq "{}"
      expect(payout.stripe_method).to eq "standard"
      expect(payout.source_type).to eq "card"
      expect(payout.statement_descriptor).to be_nil
      expect(payout.status).to eq "in_transit"
      expect(payout.stripe_type).to eq "bank_account"
    end
  end
end
