require "rails_helper"

describe "sku deleted" do
  let!(:sku) { create :stripe_sku, id: "sku_00000000000000" }

  describe "#execute!" do
    it "creates the subscription" do
      expect { mock_stripe_event("sku.deleted") }
        .to change(StripeSku, :count).by(0)

      sku.reload

      expect(response.code).to eq "200"

      expect(sku.id).to eq "sku_00000000000000"
      expect(sku.inventory_quantity).to eq 50
      expect(sku.inventory_type).to eq "finite"
      expect(sku.inventory_value).to eq nil
      expect(sku.livemode).to eq false
      expect(sku.metadata).to eq "{}"
      expect(sku.price.format).to eq "$15.00"
      expect(sku.stripe_product_id).to eq "prod_00000000000000"
      expect(sku.deleted_at).to be > 1.minute.ago
    end
  end
end
