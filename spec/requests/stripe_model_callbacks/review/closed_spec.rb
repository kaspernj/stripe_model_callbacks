require "rails_helper"

describe "review closed" do
  let!(:review) { create :stripe_review, id: "prv_00000000000000" }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/review/review.closed.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "creates the subscription" do
      expect { PublicActivity.with_tracking { post "/stripe-events", params: payload } }
        .to change(StripeReview, :count).by(0)
        .and change(PublicActivity::Activity.where(key: "stripe_review.closed"), :count).by(1)

      review.reload

      expect(response.code).to eq "200"

      expect(review.id).to eq "prv_00000000000000"
      expect(review.stripe_charge_id).to eq "ch_00000000000000"
      expect(review.created).to eq Time.zone.parse("2018-02-08 12:07:22")
      expect(review.livemode).to eq false
      expect(review.open).to eq true
      expect(review.reason).to eq "rule"
    end
  end
end
