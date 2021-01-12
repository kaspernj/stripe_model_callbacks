require "rails_helper"

describe "subscription creation" do
  let(:stripe_coupon) { create :stripe_coupon }
  let!(:stripe_customer) { create :stripe_customer, stripe_id: "cus_00000000000000" }
  let(:stripe_discount) { create :stripe_discount, stripe_id: "di_00000000000000", stripe_coupon: stripe_coupon, coupon_times_redeemed: 4 }
  let!(:stripe_plan) { create :stripe_plan, stripe_id: "silver-express-898" }
  let(:stripe_subscription) { create :stripe_subscription, stripe_customer: stripe_customer, stripe_discount: stripe_discount, stripe_id: "sub_CGPu5KqP1TORKF" }
  let(:latest_invoice_id) { "in_1GoYq1J3a8kmO8fmMn28KIy2" }

  describe "#execute!" do
    it "creates the subscription" do
      expect { mock_stripe_event("customer.subscription.created") }
        .to change(StripeSubscription, :count).by(1)
        .and change(StripeSubscriptionItem, :count).by(1)

      created_subscription = StripeSubscription.last
      created_subscription_item = StripeSubscriptionItem.last

      expect(response.code).to eq "200"

      expect(created_subscription).to have_attributes(
        latest_stripe_invoice_id: latest_invoice_id,
        stripe_customer: stripe_customer,
        stripe_plan: stripe_plan,
        stripe_plans: [stripe_plan],
        stripe_discount: nil,
        stripe_discount_id: nil
      )
      expect(created_subscription_item).to have_attributes(
        stripe_id: "si_CGPX2RZhm2pE0o",
        stripe_subscription_id: "sub_CGPXJjUMVXBLSx",
        stripe_subscription: created_subscription,
        stripe_plan_id: "silver-express-898",
        stripe_plan: stripe_plan
      )
    end

    it "sets a discount" do
      send_event_action = proc do
        mock_stripe_event(
          "customer.subscription.created",
          data: {
            object: {
              discount: {
                id: "di_00000000000000",
                coupon: {
                  amount_off: nil,
                  created: 1_518_806_752,
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
                start: 1_518_820_551,
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

      expect(created_subscription).to have_attributes(
        stripe_discount_id: "di_00000000000000",
        stripe_discount: created_discount,
        stripe_plan: stripe_plan,
        stripe_plans: [stripe_plan]
      )
    end

    it "updates a subscription with an existing discount" do
      send_event_action = proc do
        mock_stripe_event(
          "customer.subscription.updated",
          data: {
            object: {
              id: stripe_subscription.stripe_id,
              discount: {
                id: "di_00000000000000",
                coupon: {
                  amount_off: nil,
                  created: 1_518_806_752,
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
                start: 1_518_820_551,
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
        .and change(StripeSubscriptionItem, :count).by(1)
        .and change(StripeDiscount, :count).by(0)

      created_subscription = StripeSubscription.last
      created_subscription_item = StripeSubscriptionItem.last

      expect(created_subscription).to have_attributes(
        stripe_discount_id: "di_00000000000000",
        stripe_discount: stripe_discount,
        stripe_plan: stripe_plan,
        stripe_plans: [stripe_plan]
      )
      expect(created_subscription_item).to have_attributes(
        stripe_subscription: created_subscription,
        quantity: 1,
        stripe_plan_id: "silver-express-898",
        stripe_plan: stripe_plan
      )
      expect(stripe_discount.reload.coupon_times_redeemed).to eq 4
    end
  end
end
