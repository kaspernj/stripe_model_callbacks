require "rails_helper"

describe StripePaymentIntent, :stripe_mock do
  let(:stripe_payment_intent) { create :stripe_payment_intent, :with_stripe_mock }

  describe "#cancel" do
    it "cancels the payment intent" do
      expect(Stripe::PaymentIntent).to receive(:cancel).with(stripe_payment_intent.stripe_id).and_call_original

      stripe_payment_intent.cancel

      expect(stripe_payment_intent).to have_attributes(
        status: "canceled"
      )
    end
  end

  describe "#capture" do
    it "captures the payment intent" do
      expect(Stripe::PaymentIntent).to receive(:capture).with(stripe_payment_intent.stripe_id).and_call_original

      stripe_payment_intent.capture

      expect(stripe_payment_intent).to have_attributes(
        status: "succeeded"
      )
    end
  end

  describe "#confirm" do
    it "confirms the payment intent" do
      expect(Stripe::PaymentIntent).to receive(:confirm).with(stripe_payment_intent.stripe_id).and_call_original

      stripe_payment_intent.confirm

      expect(stripe_payment_intent).to have_attributes(
        status: "succeeded"
      )
    end
  end
end
