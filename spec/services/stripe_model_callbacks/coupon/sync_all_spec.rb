require "rails_helper"

describe StripeModelCallbacks::Coupon::SyncAll, :stripe_mock do
  it "creates the model locally" do
    Stripe::Coupon.create(duration: "repeating", duration_in_months: 3, percent_off: 25)

    expect { StripeModelCallbacks::Coupon::SyncAll.execute! }
      .to change(StripeCoupon, :count).by(1)

    created_coupon = StripeCoupon.last!

    expect(created_coupon).to have_attributes(
      duration: "repeating",
      percent_off: 25,
      stripe_id: "test_coupon_1"
    )
  end
end
