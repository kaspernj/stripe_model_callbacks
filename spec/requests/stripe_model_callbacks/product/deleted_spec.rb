require "rails_helper"

describe "product deleted" do
  let!(:product) { create :stripe_product, stripe_id: "prod_00000000000000" }

  describe "#execute!" do
    it "creates the subscription" do
      expect { mock_stripe_event("product.deleted") }
        .to change(StripeProduct, :count).by(0)
        .and change(ActiveRecordAuditable::Audit.where_type("StripeProduct").where_action("deleted"), :count).by(1)

      product.reload

      expect(response).to have_http_status :ok

      expect(product).to have_attributes(
        stripe_id: "prod_00000000000000",
        active: false,
        created: Time.zone.parse("2018-02-04 16:49:05"),
        updated: Time.zone.parse("2018-02-04 16:49:05"),
        name: "Extra Large",
        product_type: "service"
      )
      expect(product.deleted_at).to be > 1.minute.ago
    end
  end
end
