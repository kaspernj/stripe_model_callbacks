require "rails_helper"

describe "customer source created" do
  let!(:stripe_customer) { create :stripe_customer, stripe_id: "cus_000000000" }

  describe "#execute!" do
    it "creates a source for the customer" do
      expect { mock_stripe_event("customer.source.created") }
        .to change(StripeSource, :count).by(1)

      created_source = StripeSource.last

      expect(response.code).to eq "200"

      expect(created_source.stripe_id).to eq "src_00000000000000"
      expect(created_source.currency).to eq "usd"
      expect(created_source.created).to eq Time.zone.parse("2020-03-17 12:18:52")
      expect(created_source.owner_email).to eq "jenny.rosen@example.com"
    end

    it "creates a card when its a card that is given" do
      expect { mock_stripe_event("customer.source.created.card") }
        .to change(StripeCard, :count).by(1)

      created_card = StripeCard.last

      expect(response.code).to eq "200"

      expect(created_card.stripe_id).to eq "card_000000000"
      expect(created_card.address_city).to eq ""
      expect(created_card.address_country).to eq ""
      expect(created_card.address_line1).to eq ""
      expect(created_card.address_line1_check).to eq ""
      expect(created_card.address_line2).to eq ""
      expect(created_card.address_state).to eq ""
      expect(created_card.address_zip).to eq ""
      expect(created_card.address_zip_check).to eq ""
      expect(created_card.brand).to eq "Visa"
      expect(created_card.country).to eq "DK"
      expect(created_card.stripe_customer_id).to eq "cus_000000000"
      expect(created_card.stripe_customer).to eq stripe_customer
      expect(created_card.cvc_check).to eq "pass"
      expect(created_card.dynamic_last4).to eq ""
      expect(created_card.exp_month).to eq 9
      expect(created_card.exp_year).to eq 2029
      expect(created_card.fingerprint).to eq "asdvawefgawvafg"
      expect(created_card.funding).to eq "debit"
      expect(created_card.last4).to eq "0062"
      expect(created_card.name).to eq ""
      expect(created_card.tokenization_method).to eq ""
    end
  end
end
