require "rails_helper"

describe "tax rate created" do
  describe "#execute!" do
    it "creates the tax rate" do
      expect { mock_stripe_event("tax_rate.created") }
        .to change(StripeTaxRate, :count).by(1)

      created_tax_rate = StripeTaxRate.last!

      expect(response.code).to eq "200"

      expect(created_tax_rate).to have_attributes(
        created: Time.zone.parse("2020-12-23 20:26:11"),
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
