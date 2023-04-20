require "rails_helper"

describe "customer updating" do
  let!(:stripe_customer) { create :stripe_customer, stripe_id: "cus_00000000000000" }

  describe "#execute!" do
    it "updates the given customer" do
      mock_stripe_event("customer.updated")

      stripe_customer.reload

      expect(response).to have_http_status :ok
      expect(stripe_customer.email).to eq "test@example.com"
      expect(stripe_customer.default_source).to eq "card_000000000"
    end
  end
end
