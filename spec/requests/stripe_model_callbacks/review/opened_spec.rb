require "rails_helper"

describe "review opened" do
  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/review/review.opened.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "creates the subscription" do
      expect { PublicActivity.with_tracking { post "/stripe-events", params: payload } }
        .to change(StripeReview, :count).by(1)
        .and change(PublicActivity::Activity.where(key: "stripe_review.create"), :count).by(1)

      created_review = StripeReview.last

      expect(response.code).to eq "200"

      expect(created_review.id).to eq "prv_00000000000000"
      expect(created_review.stripe_charge_id).to eq "ch_00000000000000"
      expect(created_review.created).to eq Time.zone.parse("2018-02-08 12:06:46")
      expect(created_review.livemode).to eq false
      expect(created_review.open).to eq true
      expect(created_review.reason).to eq "rule"
    end
  end
end
