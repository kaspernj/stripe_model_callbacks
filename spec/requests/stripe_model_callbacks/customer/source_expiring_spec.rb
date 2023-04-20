require "rails_helper"

describe "customer source expiring" do
  let!(:stripe_customer) { create :stripe_customer, stripe_id: "cus_00000000000000" }
  let!(:stripe_source) { create :stripe_source, stripe_id: "src_00000000000000" }

  describe "#execute!" do
    it "adds an activity and updates the source" do
      expect { PublicActivity.with_tracking { mock_stripe_event("customer.source.expiring") } }
        .to change(StripeSource, :count).by(0)
        .and change(PublicActivity::Activity.where(key: "stripe_source.expiring"), :count).by(1)

      stripe_source.reload

      expect(response).to have_http_status :ok

      expect(stripe_source.stripe_id).to eq "src_00000000000000"
      expect(stripe_source.currency).to eq "usd"
      expect(stripe_source.created).to eq Time.zone.parse("2018-02-06 12:25:06")
      expect(stripe_source.owner_email).to eq "jenny.rosen@example.com"
    end
  end
end
