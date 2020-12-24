require "rails_helper"

describe StripeTaxRate do
  describe "#create_on_stripe!" do
    it "creates a tax rate on Stripe", :stripe_mock do
      created_vat_rate = StripeTaxRate.create_on_stripe!(
        display_name: "Test tax rate",
        inclusive: false,
        percentage: 25
      )

      expect(created_vat_rate).to have_attributes(
        display_name: "Test tax rate",
        inclusive: false,
        percentage: 25.0
      )
    end
  end
end
