require "rails_helper"

describe "customer discount deleted" do
  let!(:coupon) { create :stripe_coupon, id: "25OFF_00000000000000" }
  let!(:customer) { create :stripe_customer, id: "cus_00000000000000" }
  let!(:discount) { create :stripe_discount, coupon: coupon, customer: customer }

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    expect(Stripe::Webhook).to receive(:construct_event).and_return(event)
  end

  let(:payload) { File.read("spec/fixtures/stripe_events/customer/customer.discount.deleted.json") }
  before { bypass_event_signature(payload) }

  describe "#execute!" do
    it "adds an activity and updates the existing discount" do
      expect { PublicActivity.with_tracking { post "/stripe-events", params: payload } }
        .to change(StripeDiscount, :count).by(0)
        .and change(PublicActivity::Activity.where(key: "stripe_discount.deleted"), :count).by(1)

      discount.reload

      expect(response.code).to eq "200"

      expect(discount.coupon_id).to eq "25OFF_00000000000000"
      expect(discount.coupon).to eq coupon
      expect(discount.customer_id).to eq "cus_00000000000000"
      expect(discount.customer).to eq customer
      expect(discount.coupon_amount_off).to eq nil
      expect(discount.coupon_created).to eq Time.zone.parse("2018-02-06 12:29:43")
      expect(discount.coupon_currency).to eq nil
      expect(discount.coupon_duration).to eq "repeating"
      expect(discount.coupon_duration_in_months).to eq 3
      expect(discount.coupon_livemode).to eq false
      expect(discount.coupon_max_redemptions).to eq nil
      expect(discount.coupon_metadata).to eq "{}"
      expect(discount.coupon_percent_off).to eq 25
      expect(discount.coupon_redeem_by).to eq nil
      expect(discount.coupon_times_redeemed).to eq 0
      expect(discount.coupon_valid).to eq true
      expect(discount.start).to eq Time.zone.parse("2018-02-06 12:29:43")
      expect(discount.end).to eq Time.zone.parse("2018-05-06 12:29:43")
      expect(discount.subscription_id).to eq nil
      expect(discount.subscription).to eq nil
      expect(discount.deleted_at).to be > 1.minute.ago
    end
  end
end
