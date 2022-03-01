require "rails_helper"

describe "transfer created" do
  describe "#execute!" do
    it "creates the transfer" do
      expect { mock_stripe_event("transfer.created") }
        .to change(StripeTransfer, :count).by(1)

      created_transfer = StripeTransfer.last

      expect(response.code).to eq "200"

      expect(created_transfer.stripe_id).to eq "tr_00000000000000"
      expect(created_transfer.amount.format).to eq "$11.00"
      expect(created_transfer.amount_reversed.format).to eq "$0.00"
      expect(created_transfer.balance_transaction).to eq "txn_00000000000000"
      expect(created_transfer.created).to eq Time.zone.parse("2018-02-06 08:53:31")
      expect(created_transfer.currency).to eq "usd"
      expect(created_transfer.description).to be_nil
      expect(created_transfer.destination).to eq "acct_1Brq15AT5SYrvIfd"
      expect(created_transfer.destination_payment).to eq "py_CH0DW4ihzdQQCd"
      expect(created_transfer.livemode).to be false
      expect(created_transfer.metadata).to eq "{}"
      expect(created_transfer.reversed?).to be false
      expect(created_transfer.source_transaction).to be_nil
      expect(created_transfer.source_type).to eq "card"
      expect(created_transfer.transfer_group).to be_nil
      expect(created_transfer.status).to eq "pending"
    end
  end
end
