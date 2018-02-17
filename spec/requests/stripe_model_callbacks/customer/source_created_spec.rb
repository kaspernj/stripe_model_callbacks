require "rails_helper"

describe "customer source updated" do
  describe "#execute!" do
    it "updates the subscription" do
      expect { mock_stripe_event("customer.source.created") }
        .to change(StripeSource, :count).by(1)

      created_source = StripeSource.last

      expect(response.code).to eq "200"

      expect(created_source.id).to eq "src_00000000000000"
      expect(created_source.currency).to eq "usd"
      expect(created_source.created).to eq Time.zone.parse("2018-02-06 12:18:52")
      expect(created_source.owner_email).to eq "jenny.rosen@example.com"
    end
  end
end
