require "rails_helper"

describe "sku created" do
  describe "#execute!" do
    it "creates the subscription" do
      expect { mock_stripe_event("sku.created") }
        .to change(StripeSku, :count).by(1)

      created_sku = StripeSku.last

      expect(response).to have_http_status :ok

      expect(created_sku.stripe_id).to eq "sku_00000000000000"
      expect(created_sku.inventory_quantity).to eq 50
      expect(created_sku.inventory_type).to eq "finite"
      expect(created_sku.inventory_value).to be_nil
      expect(created_sku.livemode).to be false
      expect(created_sku.metadata).to eq "{}"
      expect(created_sku.price.format).to eq "$15.00"
      expect(created_sku.stripe_product_id).to eq "prod_00000000000000"
    end
  end
end
