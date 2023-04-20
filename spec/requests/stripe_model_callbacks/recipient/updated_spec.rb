require "rails_helper"

describe "recipient created" do
  let!(:recipient) { create :stripe_recipient, stripe_id: "rp_00000000000000" }

  describe "#execute!" do
    it "updates the given recipient" do
      expect { mock_stripe_event("recipient.updated") }
        .to change(StripeRecipient, :count).by(0)

      recipient.reload

      expect(response).to have_http_status :ok

      expect(recipient.stripe_id).to eq "rp_00000000000000"
      expect(recipient.description).to eq "Recipient for John Doe"
      expect(recipient.email).to eq "test@example.com"
      expect(recipient.name).to eq "John Doe"
      expect(recipient.stripe_type).to eq "individual"
    end
  end
end
