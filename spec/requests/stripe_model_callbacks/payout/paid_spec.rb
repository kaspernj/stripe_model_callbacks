require "rails_helper"

describe "payout paid" do
  let!(:payout) { create :stripe_payout, stripe_id: "po_00000000000000" }

  describe "#execute!" do
    it "creates the subscription" do
      expect { mock_stripe_event("payout.paid") }
        .to change(StripePayout, :count).by(0)
        .and change(PublicActivity::Activity.where(key: "stripe_payout.paid"), :count).by(1)

      payout.reload

      expect(response).to have_http_status :ok

      expect(payout.stripe_id).to eq "po_00000000000000"
      expect(payout.amount.format).to eq "$11.00"
      expect(payout.arrival_date).to eq Time.zone.parse("2018-02-06 09:53:18")
      expect(payout.automatic).to be true
      expect(payout.balance_transaction).to eq "txn_00000000000000"
      expect(payout.created).to eq Time.zone.parse("2018-02-06 09:53:18")
      expect(payout.currency).to eq "usd"
      expect(payout.description).to eq "STRIPE TRANSFER"
      expect(payout.destination).to eq "ba_1BsT8cAT5SYrvIfdXBCtuntu"
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
