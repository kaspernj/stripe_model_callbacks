require "rails_helper"

describe "recipient created" do
  describe "#execute!" do
    it "creates the subscription" do
      expect { mock_stripe_event("recipient.created") }
        .to change(StripeRecipient, :count).by(1)

      created_recipient = StripeRecipient.last

      expect(response.code).to eq "200"

      expect(created_recipient.stripe_id).to eq "rp_00000000000000"
      expect(created_recipient.description).to eq "Recipient for John Doe"
      expect(created_recipient.email).to eq "test@example.com"
      expect(created_recipient.name).to eq "John Doe"
      expect(created_recipient.stripe_type).to eq "individual"
    end
  end
end
