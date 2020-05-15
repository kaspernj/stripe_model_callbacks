require "rails_helper"

describe "subscription_schedule created" do
  describe "#execute!" do
    it "creates the subscription_schedule" do
      expect { mock_stripe_event("subscription_schedule.created") }
        .to change(StripeSubscriptionSchedule, :count).by(1)

      created_transfer = StripeSubscriptionSchedule.last

      expect(response.code).to eq "200"

      expect(created_transfer.stripe_id).to eq "tr_00000000000000"
      expect(created_transfer.amount.format).to eq "$11.00"
      expect(created_transfer.amount_reversed.format).to eq "$0.00"
      expect(created_transfer.balance_transaction).to eq "txn_00000000000000"
      expect(created_transfer.created).to eq Time.zone.parse("2018-02-06 08:53:31")
      expect(created_transfer.currency).to eq "usd"
      expect(created_transfer.description).to eq nil
      expect(created_transfer.destination).to eq "acct_1Brq15AT5SYrvIfd"
      expect(created_transfer.destination_payment).to eq "py_CH0DW4ihzdQQCd"
      expect(created_transfer.livemode).to eq false
      expect(created_transfer.metadata).to eq "{}"
      expect(created_transfer.reversed?).to eq false
      expect(created_transfer.source_transaction).to eq nil
      expect(created_transfer.source_type).to eq "card"
      expect(created_transfer.transfer_group).to eq nil
      expect(created_transfer.status).to eq "pending"
    end
  end
end
