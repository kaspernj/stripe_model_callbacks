require "rails_helper"

describe "customer updating" do
  let!(:stripe_customer) { create :stripe_customer, id: "cus_00000000000000" }

  describe "#execute!" do
    it "updates the subscription" do
      mock_stripe_event("customer.updated")

      stripe_customer.reload

      expect(response.code).to eq "200"
      expect(stripe_customer.email).to eq "test@example.com"
    end
  end
end
