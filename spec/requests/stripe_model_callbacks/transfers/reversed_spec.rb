require "rails_helper"

describe "transfer reversed" do
  let!(:transfer) { create :stripe_transfer, identifier: "tr_00000000000000" }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/transfer/transfer.reversed.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "logs an activity and updates the transfer" do
      expect { PublicActivity.with_tracking { post "/stripe-events", params: payload } }
        .to change(StripeTransfer, :count).by(0)
        .and change(PublicActivity::Activity.where(key: "stripe_transfer.reversed"), :count).by(1)

      transfer.reload

      expect(response.code).to eq "200"

      expect(transfer.identifier).to eq "tr_00000000000000"
      expect(transfer.amount.format).to eq "$11.00"
      expect(transfer.amount_reversed.format).to eq "$0.00"
      expect(transfer.balance_transaction).to eq "txn_00000000000000"
      expect(transfer.created).to eq Time.zone.parse("2018-02-06 08:54:49")
      expect(transfer.currency).to eq "usd"
      expect(transfer.description).to eq nil
      expect(transfer.destination).to eq "acct_1Brq15AT5SYrvIfd"
      expect(transfer.destination_payment).to eq "py_CH0EOf6bFQq9g2"
      expect(transfer.livemode).to eq false
      expect(transfer.metadata).to eq "{}"
      expect(transfer.reversed?).to eq false
      expect(transfer.source_transaction).to eq nil
      expect(transfer.source_type).to eq "card"
      expect(transfer.transfer_group).to eq nil
    end
  end
end
