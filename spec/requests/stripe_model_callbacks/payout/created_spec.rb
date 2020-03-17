require "rails_helper"

describe "payout created" do
  describe "#execute!" do
    it "creates the subscription" do
      expect { mock_stripe_event("payout.created") }
        .to change(StripePayout, :count).by(1)

      created_payout = StripePayout.last

      expect(response.code).to eq "200"

      expect(created_payout.stripe_id).to eq "po_00000000000000"
      expect(created_payout.amount.format).to eq "$11.00"
      expect(created_payout.arrival_date).to eq Time.zone.parse("2020-03-17 09:52:50")
      expect(created_payout.automatic).to eq true
      expect(created_payout.balance_transaction).to eq "txn_00000000000000"
      expect(created_payout.created).to eq Time.zone.parse("2020-03-17 09:52:50")
      expect(created_payout.currency).to eq "usd"
      expect(created_payout.description).to eq "STRIPE TRANSFER"
      expect(created_payout.destination).to eq "ba_1BsT8AAT5SYrvIfdkZIbPLDE"
      expect(created_payout.failure_balance_transaction).to eq nil
      expect(created_payout.failure_code).to eq nil
      expect(created_payout.failure_message).to eq nil
      expect(created_payout.livemode).to eq false
      expect(created_payout.metadata).to eq "{}"
      expect(created_payout.stripe_method).to eq "standard"
      expect(created_payout.source_type).to eq "card"
      expect(created_payout.statement_descriptor).to eq nil
      expect(created_payout.status).to eq "in_transit"
      expect(created_payout.stripe_type).to eq "bank_account"
    end
  end
end
