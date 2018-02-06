require "rails_helper"

describe "coupon updated" do
  let!(:coupon) { create :stripe_coupon, id: "25OFF_00000000000000" }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/coupon/coupon.updated.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "updates the coupon" do
      expect { post "/stripe-events", params: payload }
        .to change(StripeCoupon, :count).by(0)

      coupon.reload

      expect(response.code).to eq "200"

      expect(coupon.id).to eq "25OFF_00000000000000"
      expect(coupon.amount_off).to eq nil
      expect(coupon.created).to eq Time.zone.parse("2018-02-06 09:28:29")
      expect(coupon.currency).to eq nil
      expect(coupon.duration).to eq "repeating"
      expect(coupon.duration_in_months).to eq 3
      expect(coupon.livemode).to eq false
      expect(coupon.max_redemptions).to eq nil
      expect(coupon.metadata).to eq "{}"
      expect(coupon.percent_off).to eq 25
      expect(coupon.redeem_by).to eq nil
      expect(coupon.times_redeemed).to eq 0
      expect(coupon.stripe_valid).to eq true
    end
  end
end
