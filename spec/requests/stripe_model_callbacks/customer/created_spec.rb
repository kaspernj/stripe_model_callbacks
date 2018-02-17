require "rails_helper"

describe "customer creation" do
  describe "#execute!" do
    it "creates a customer" do
      expect { mock_stripe_event("customer.created") }
        .to change(StripeCustomer, :count).by(1)

      created_customer = StripeCustomer.last

      expect(response.code).to eq "200"
      expect(created_customer.id).to eq "cus_2wm5EgmRGEiyPO"
      expect(created_customer.livemode).to eq false
      expect(created_customer.description).to eq "id:12345"
      expect(created_customer.delinquent).to eq false
      expect(created_customer.metadata).to eq "{}"
      expect(created_customer.email).to eq "user@example.com"
      expect(created_customer.stripe_subscriptions).to be_empty
      expect(created_customer.discount).to eq nil
      expect(created_customer.account_balance).to eq 0
    end
  end
end
