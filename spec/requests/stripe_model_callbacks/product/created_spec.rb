require "rails_helper"

describe "product created" do
  describe "#execute!" do
    it "creates the subscription" do
      expect { mock_stripe_event("product.created") }
        .to change(StripeProduct, :count).by(1)

      created_product = StripeProduct.last

      expect(response.code).to eq "200"

      expect(created_product.stripe_id).to eq "prod_00000000000000"
    end
  end
end
