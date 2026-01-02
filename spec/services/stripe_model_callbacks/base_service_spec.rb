require "rails_helper"

describe StripeModelCallbacks::BaseService do
  let(:service_class) do
    Class.new(described_class) do
      def perform
        succeed!
      end
    end
  end
  let(:stripe_object) { double("StripeObject", object: "invoice", id: "in_123") }
  let(:stripe_event) { double("StripeEvent", data: double(object: stripe_object)) }

  it "acquires an advisory lock with a timeout" do
    expect(StripeModelCallbacks::ApplicationRecord).to receive(:with_advisory_lock!)
      .with("stripe-invoice-id-in_123", timeout_seconds: 10)
      .and_yield

    expect { service_class.execute_with_advisory_lock!(event: stripe_event) }.not_to raise_error
  end
end
