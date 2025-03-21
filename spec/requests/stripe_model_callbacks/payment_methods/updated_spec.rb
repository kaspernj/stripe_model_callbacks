require "rails_helper"

describe "payment methods - updated" do
  let!(:customer) { create :stripe_customer, stripe_id: "cus_NiCY7UI5u0pbJH" }
  let!(:payment_method) { create :stripe_payment_method, stripe_id: "pm_1MxwglIICJxvfdbRkDNKMCwZ" }

  describe "#execute!" do
    it "creates the subscription" do
      expect { mock_stripe_event("payment_method.updated") }
        .to change(StripePaymentMethod, :count).by(0)
        .and change(ActiveRecordAuditable::Audit.where_type("StripePaymentMethod").where_action("updated"), :count).by(1)

      expect(response).to have_http_status :ok
      expect(payment_method.reload).to have_attributes(
        billing_details: {
          "address" => {
            "city" => nil,
            "country" => "DK",
            "line1" => nil,
            "line2" => nil,
            "postal_code" => nil,
            "state" => nil
          },
          "email" => nil,
          "name" => nil,
          "phone" => nil
        },
        card: {
          "brand" => "mastercard",
          "checks" => {
            "address_line1_check" => nil,
            "address_postal_code_check" => nil,
            "cvc_check" => "pass"
          },
          "country" => "DK",
          "exp_month" => 6,
          "exp_year" => 2023,
          "fingerprint" => "QJ3sKGzehiISoOQ3",
          "funding" => "debit",
          "generated_from" => nil,
          "last4" => "7080",
          "networks" => {
            "available" => [
              "mastercard"
            ],
            "preferred" => nil
          },
          "three_d_secure_usage" => {
            "supported" => true
          },
          "wallet" => nil
        },
        created: 1_681_755_727,
        customer: "cus_NiCY7UI5u0pbJH",
        livemode: true,
        metadata: {},
        stripe_customer: customer,
        stripe_id: "pm_1MxwglIICJxvfdbRkDNKMCwZ",
        stripe_type: "card"
      )
    end
  end
end
