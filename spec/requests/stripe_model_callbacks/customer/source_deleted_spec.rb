require "rails_helper"

describe "customer source deleted" do
  let!(:stripe_customer) { create :stripe_customer, id: "cus_00000000000000" }
  let!(:stripe_source) { create :stripe_source, id: "src_00000000000000" }

  describe "#execute!" do
    it "adds an activity and updates the source" do
      expect { PublicActivity.with_tracking { mock_stripe_event("customer.source.deleted") } }
        .to change(StripeSource, :count).by(0)
        .and change(PublicActivity::Activity.where(key: "stripe_source.deleted"), :count).by(1)

      stripe_source.reload

      expect(response.code).to eq "200"

      expect(stripe_source.id).to eq "src_00000000000000"
      expect(stripe_source.currency).to eq "usd"
      expect(stripe_source.created).to eq Time.zone.parse("2018-02-06 12:27:27")
      expect(stripe_source.owner_email).to eq "jenny.rosen@example.com"
    end
  end
end
