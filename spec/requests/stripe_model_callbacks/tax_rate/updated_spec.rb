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
        created: Time.zone.parse("2020-12-23 20:26:41"),
        description: "VAT Germany",
        display_name: "VAT",
        inclusive: false,
        jurisdiction: "DE",
        percentage: 16.0,
        stripe_id: "txr_00000000000000",
        tax_type: "vat"
      )
    end
  end
end
