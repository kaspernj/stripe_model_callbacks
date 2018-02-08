require "rails_helper"

describe "account external account created" do
  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/account/account.external_account.created.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "creates the bank account" do
      expect { post "/stripe-events", params: payload }
        .to change(StripeBankAccount, :count).by(1)

      created_bank_account = StripeBankAccount.last

      expect(response.code).to eq "200"

      expect(created_bank_account.id).to eq "ba_00000000000000"
      expect(created_bank_account.stripe_account_id).to eq "acct_00000000000000"
      expect(created_bank_account.account_holder_name).to eq "Jane Austen"
      expect(created_bank_account.account_holder_type).to eq "individual"
      expect(created_bank_account.bank_name).to eq "STRIPE TEST BANK"
      expect(created_bank_account.country).to eq "US"
      expect(created_bank_account.currency).to eq "dkk"
      expect(created_bank_account.default_for_currency?).to eq false
      expect(created_bank_account.fingerprint).to eq "8hxBTDA6RPbX37IN"
      expect(created_bank_account.last4).to eq "6789"
      expect(created_bank_account.metadata).to eq "{}"
      expect(created_bank_account.routing_number).to eq "110000000"
      expect(created_bank_account.status).to eq "new"
    end
  end
end
