require "rails_helper"

describe "tax rate created" do
  describe "#execute!" do
    it "creates the tax rate" do
      expect { mock_stripe_event("tax_rate.created") }
        .to change(StripeTaxRate, :count).by(1)

      created_tax_rate = StripeTaxRate.last!

      expect(response.code).to eq "200"

      expect(created_tax_rate).to have_attributes(
        stripe_id: "txr_00000000000000"
      )
    end
  end
end
