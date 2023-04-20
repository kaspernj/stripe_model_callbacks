require "rails_helper"

describe "customer deleted" do
  let!(:stripe_customer) { create :stripe_customer, stripe_id: "cus_00000000000000" }

  describe "#execute!" do
    it "deletes the given customer" do
      mock_stripe_event("customer.deleted")

      stripe_customer.reload

      expect(response).to have_http_status :ok
      expect(stripe_customer.deleted_at).to be > 1.minute.ago
    end
  end
end
