require "rails_helper"

describe "error handling" do
  let(:configuration) { StripeModelCallbacks::Configuration.current }
  let!(:stripe_coupon) { create :stripe_coupon, stripe_id: "some-coupon" }
  let!(:stripe_customer) { create :stripe_customer, stripe_id: "cus_CGNFgjPGtHlvXI" }

  after do
    configuration.instance_variable_set(:@on_error_callbacks, [])
  end

  it "creates an invoice", :aggregate_failure do
    expect(StripeModelCallbacks::Invoice::UpdatedService).to receive(:reported_execute!).and_raise("BOOM!")

    called = false
    callback = proc do
      called = true
    end

    configuration.instance_variable_set(:@on_error_callbacks, [callback])

    expect { PublicActivity.with_tracking { mock_stripe_event("invoice.created") } }
      .to raise_error(RuntimeError, "BOOM!")
      .and change(StripeInvoice, :count).by(0)

    expect(called).to eq true
  end
end
