require "rails_helper"

describe "customer source updated" do
  let!(:stripe_source) { create :stripe_source, stripe_id: "src_00000000000000" }

  describe "#execute!" do
    it "updates the given source" do
      expect { mock_stripe_event("customer.source.updated") }
        .to change(StripeSource, :count).by(0)

      stripe_source.reload

      expect(response).to have_http_status :ok

      expect(stripe_source.stripe_id).to eq "src_00000000000000"
      expect(stripe_source.currency).to eq "usd"
      expect(stripe_source.created).to eq Time.zone.parse("2018-02-04 19:29:53")
      expect(stripe_source.owner_email).to eq "jenny.rosen@example.com"
    end
  end
end
