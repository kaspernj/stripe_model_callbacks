require "rails_helper"

describe "customer updating" do
  let!(:stripe_customer) { create :stripe_customer, stripe_id: "cus_00000000000000" }

  describe "#execute!" do
    it "updates the given customer" do
      mock_stripe_event("customer.updated")

      stripe_customer.reload

      expect(response.code).to eq "200"
      expect(stripe_customer.email).to eq "test@example.com"
    end
  end
end
