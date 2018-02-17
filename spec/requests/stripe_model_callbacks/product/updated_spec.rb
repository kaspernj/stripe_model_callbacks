require "rails_helper"

describe "product updated" do
  let!(:product) { create :stripe_product, id: "prod_00000000000000" }

  describe "#execute!" do
    it "creates the subscription" do
      expect { mock_stripe_event("product.updated") }
        .to change(StripeProduct, :count).by(0)

      product.reload

      expect(response.code).to eq "200"

      expect(product.id).to eq "prod_00000000000000"
      expect(product.active?).to eq false
      expect(product.created).to eq Time.zone.parse("2018-02-04 16:49:05")
      expect(product.updated).to eq Time.zone.parse("2018-02-04 16:49:05")
      expect(product.name).to eq "Extra Large"
    end
  end
end
