require "rails_helper"

describe StripeCard do
  let(:stripe_card) { create :stripe_card }

  describe "#to_stripe" do
    it "returns a Stripe::Card instance" do
      fake_card = double(brand: "Peakcorp Card")

      expect(Stripe::Customer)
        .to receive(:retrieve_source).with(a_string_matching(/\Acustomer-identifier-(\d+)\Z/), a_string_matching(/\Astripe-card-(\d+)\Z/)).and_return(fake_card)

      result = stripe_card.to_stripe

      expect(result.brand).to eq "Peakcorp Card"
    end
  end
end
