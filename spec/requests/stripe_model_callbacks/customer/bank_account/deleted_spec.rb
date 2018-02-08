require "rails_helper"

describe "customer bank account deleted" do
  let!(:bank_account) { create :stripe_bank_account, id: "ba_00000000000000" }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/customer/customer.bank_account.deleted.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "ends the subscription" do
      expect { PublicActivity.with_tracking { post "/stripe-events", params: payload } }
        .to change(PublicActivity::Activity.where(key: "stripe_bank_account.customer_bank_account_deleted"), :count).by(1)

      bank_account.reload

      expect(response.code).to eq "200"

      expect(bank_account.id).to eq "ba_00000000000000"
      expect(bank_account.stripe_account_id).to eq "acct_00000000000000"
      expect(bank_account.account_holder_name).to eq "Jane Austen"
      expect(bank_account.account_holder_type).to eq "individual"
      expect(bank_account.bank_name).to eq "STRIPE TEST BANK"
      expect(bank_account.country).to eq "US"
      expect(bank_account.currency).to eq "dkk"
      expect(bank_account.default_for_currency?).to eq false
      expect(bank_account.fingerprint).to eq "8hxBTDA6RPbX37IN"
      expect(bank_account.last4).to eq "6789"
      expect(bank_account.metadata).to eq "{}"
      expect(bank_account.routing_number).to eq "110000000"
      expect(bank_account.status).to eq "new"
    end
  end
end
