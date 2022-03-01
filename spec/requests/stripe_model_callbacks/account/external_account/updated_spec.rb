require "rails_helper"

describe "account external account updated" do
  let!(:bank_account) { create :stripe_bank_account, stripe_id: "ba_00000000000000" }

  describe "#execute!" do
    it "updates the bank account" do
      expect { PublicActivity.with_tracking { mock_stripe_event("account.external_account.updated") } }
        .to change(StripeBankAccount, :count).by(0)
        .and change(PublicActivity::Activity.where(key: "stripe_bank_account.update"), :count).by(1)

      bank_account.reload

      expect(response.code).to eq "200"

      expect(bank_account.stripe_id).to eq "ba_00000000000000"
      expect(bank_account.stripe_account_id).to eq "acct_00000000000000"
      expect(bank_account.account_holder_name).to eq "Jane Austen"
      expect(bank_account.account_holder_type).to eq "individual"
      expect(bank_account.bank_name).to eq "STRIPE TEST BANK"
      expect(bank_account.country).to eq "US"
      expect(bank_account.currency).to eq "dkk"
      expect(bank_account.default_for_currency?).to be false
      expect(bank_account.fingerprint).to eq "8hxBTDA6RPbX37IN"
      expect(bank_account.last4).to eq "6789"
      expect(bank_account.metadata).to eq "{}"
      expect(bank_account.routing_number).to eq "110000000"
      expect(bank_account.status).to eq "new"
    end
  end
end
