require "rails_helper"

describe "subscription creation" do
  let(:stripe_coupon) { create :stripe_coupon }
  let!(:stripe_customer) { create :stripe_customer, stripe_id: "cus_00000000000000" }
  let(:stripe_discount) { create :stripe_discount, stripe_coupon: stripe_coupon, coupon_times_redeemed: 4 }
  let!(:stripe_plan) { create :stripe_plan, stripe_id: "silver-express-898" }
  let(:stripe_subscription) { create :stripe_subscription, stripe_customer: stripe_customer, stripe_discount: stripe_discount }

  describe "#execute!" do
    it "creates the subscription" do
      expect { mock_stripe_event("customer.subscription.created") }
        .to change(StripeSubscription, :count).by(1)
        .and change(StripeSubscriptionItem, :count).by(1)

      created_subscription = StripeSubscription.last
      created_subscription_item = StripeSubscriptionItem.last

      expect(response.code).to eq "200"

      expect(created_subscription.stripe_customer).to eq stripe_customer
      expect(created_subscription.stripe_plan).to eq stripe_plan
      expect(created_subscription.stripe_discount).to eq nil
      expect(created_subscription.stripe_discount_id).to eq nil

      expect(created_subscription_item.stripe_id).to eq "si_CGPX2RZhm2pE0o"
      expect(created_subscription_item.stripe_subscription_id).to eq "sub_CGPXJjUMVXBLSx"
      expect(created_subscription_item.stripe_subscription).to eq created_subscription
      expect(created_subscription_item.stripe_plan_id).to eq "silver-express-898"
      expect(created_subscription_item.stripe_plan).to eq stripe_plan
    end

    it "sets a discount" do
      send_event_action = proc do
        mock_stripe_event(
          "customer.subscription.created",
          data: {
            object: {
              discount: {
                coupon: {
                  amount_off: nil,
                  created: 1518806752,
                  currency: nil,
                  duration: "forever",
                  duration_in_months: nil,
                  id: stripe_coupon.stripe_id,
                  livemode: false,
                  max_redemptions: nil,
                  percent_off: 100,
                  redeem_by: nil,
                  times_redeemed: 9,
                  valid: true
                },
                customer: stripe_customer.stripe_id,
                end: nil,
                percent_off: 50,
                start: 1518820551,
                subscription: "sub_CGPXJjUMVXBLSx"
              }
            }
          }
        )
      end

      expect { send_event_action.call }
        .to change(StripeSubscription, :count).by(1)
        .and change(StripeDiscount, :count).by(1)

      created_discount = StripeDiscount.last
      created_subscription = StripeSubscription.last

      expect(created_subscription.stripe_discount_id).to eq created_discount.id.to_s
      expect(created_subscription.stripe_discount).to eq created_discount
    end

    it "updates a subscription with an existing discount" do
      send_event_action = proc do
        mock_stripe_event(
          "customer.subscription.updated",
          data: {
            object: {
              id: stripe_subscription.stripe_id,
              discount: {
                coupon: {
                  amount_off: nil,
                  created: 1518806752,
                  currency: nil,
                  duration: "forever",
                  duration_in_months: nil,
                  id: stripe_coupon.stripe_id,
                  livemode: false,
                  max_redemptions: nil,
                  percent_off: 100,
                  redeem_by: nil,
                  times_redeemed: 9,
                  valid: true
                },
                customer: stripe_customer.stripe_id,
                end: nil,
                percent_off: 50,
                start: 1518820551,
                subscription: "sub_CGPXJjUMVXBLSx"
              }
            }
          }
        )
      end

      stripe_subscription.update!(stripe_discount: stripe_discount)
      expect(stripe_discount.coupon_times_redeemed).to eq 4

      expect { send_event_action.call }
        .to change(StripeSubscription, :count).by(0)
        .and change(StripeSubscriptionItem, :count).by(0)
        .and change(StripeDiscount, :count).by(0)

      created_subscription = StripeSubscription.last

      expect(created_subscription.stripe_discount_id).to eq stripe_discount.id.to_s
      expect(created_subscription.stripe_discount).to eq stripe_discount
      expect(stripe_discount.reload.coupon_times_redeemed).to eq 4
    end
  end
end
