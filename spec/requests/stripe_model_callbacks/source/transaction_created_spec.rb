require "rails_helper"

describe "source transaction created" do
  describe "#execute!" do
    xit "creates a new transaction" do
      expect { mock_stripe_event("source.transaction_created") }
        .to change(StripeSource, :count).by(0)

      source.reload

      expect(response.code).to eq "200"

      # Write more specs
    end
  end
end
