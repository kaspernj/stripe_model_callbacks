require "rails_helper"

describe "payment methods - attached" do
  let!(:customer) { create :stripe_customer, stripe_id: "cus_NiCY7UI5u0pbJH" }

  describe "#execute!" do
    it "creates the subscription" do
      expect { mock_stripe_event("payment_method.attached") }
        .to change(StripePaymentMethod, :count).by(1)
        .and change(Activity.where(key: "stripe_payment_method.attached"), :count).by(1)

      created_payment_method = StripePaymentMethod.last!

      expect(response).to have_http_status :ok
      expect(created_payment_method.reload).to have_attributes(
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
      expect(customer.stripe_payment_methods).to eq [created_payment_method]
    end
  end
end
