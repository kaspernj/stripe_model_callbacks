require "rails_helper"

describe "source transaction created" do
  describe "#execute!" do
    it "creates a new transaction" do
      expect { mock_stripe_event("source.transaction_created") }
        .to change(StripeSource, :count).by(0)

      expect(response).to have_http_status :ok

      # FIXME: Write more specs
    end
  end
end
