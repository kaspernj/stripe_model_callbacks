require "rails_helper"

describe "source transaction created" do
  let!(:source) { create :stripe_source, stripe_id: "src_00000000000000" }

  describe "#execute!" do
    it "creates an activity for the source" do
      expect { mock_stripe_event("source.transaction.created") }
        .to change(StripeSource, :count).by(0)
        .and change(
          ActiveRecordAuditable::Audit.where_type("StripeSource").where_action("transaction_created"),
          :count
        ).by(1)

      expect(response).to have_http_status :ok
    end
  end
end
