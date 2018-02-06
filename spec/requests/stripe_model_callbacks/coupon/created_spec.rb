require "rails_helper"

describe "coupon created" do
  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/coupon/coupon.created.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "creates the coupon" do
      expect { post "/stripe-events", params: payload }
        .to change(StripeCoupon, :count).by(1)

      created_coupon = StripeCoupon.last

      expect(response.code).to eq "200"

      expect(created_coupon.identifier).to eq "25OFF_00000000000000"
      expect(created_coupon.amount_off).to eq nil
      expect(created_coupon.created).to eq Time.zone.parse("2018-02-06 09:27:55")
      expect(created_coupon.currency).to eq nil
      expect(created_coupon.duration).to eq "repeating"
      expect(created_coupon.duration_in_months).to eq 3
      expect(created_coupon.livemode).to eq false
      expect(created_coupon.max_redemptions).to eq nil
      expect(created_coupon.metadata).to eq "{}"
      expect(created_coupon.percent_off).to eq 25
      expect(created_coupon.redeem_by).to eq nil
      expect(created_coupon.times_redeemed).to eq 0
      expect(created_coupon.stripe_valid).to eq true
    end
  end
end
