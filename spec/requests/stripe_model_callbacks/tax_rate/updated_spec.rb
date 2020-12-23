require "rails_helper"

describe "tax rate updated" do
  let!(:tax_rate) { create :stripe_tax_rate, stripe_id: "txr_00000000000000" }

  describe "#execute!" do
    it "updates the tax_rate" do
      expect { mock_stripe_event("tax_rate.updated") }
        .to change(StripeTaxRate, :count).by(0)

      tax_rate.reload

      expect(response.code).to eq "200"

      expect(tax_rate).to have_attributes(
        stripe_id: "txr_00000000000000"
      )
    end
  end
end
