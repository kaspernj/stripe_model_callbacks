require "rails_helper"

describe "customer bank account deleted" do
  let!(:bank_account) { create :stripe_bank_account, stripe_id: "ba_00000000000000" }

  describe "#execute!" do
    it "ends the subscription" do
      expect { PublicActivity.with_tracking { mock_stripe_event("customer.bank_account.deleted") } }
        .to change(PublicActivity::Activity.where(key: "stripe_bank_account.customer_bank_account_deleted"), :count).by(1)

      bank_account.reload

      expect(response).to have_http_status :ok

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
