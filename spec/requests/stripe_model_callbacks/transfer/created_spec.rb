require "rails_helper"

describe "transfer created" do
  describe "#execute!" do
    it "creates the transfer" do
      expect { mock_stripe_event("transfer.created") }
        .to change(StripeTransfer, :count).by(1)

      created_transfer = StripeTransfer.last

      expect(response.code).to eq "200"

      expect(created_transfer).to have_attributes(
        stripe_id: "tr_00000000000000",
        amount: Money.new(11_00, "USD"),
        amount_reversed: Money.new(0, "USD"),
        balance_transaction: "txn_00000000000000",
        created: Time.zone.parse("2020-03-17 18:53:55"),
        currency: "usd",
        description: nil,
        destination: "acct_1Bsw4fEKaFxLwikq",
        destination_payment: "py_GvblzJUDmEpmMd",
        livemode: false,
        metadata: "{}",
        reversed: false,
        source_transaction: nil,
        source_type: "card",
        transfer_group: nil,
        status: "pending"
      )
    end
  end
end
