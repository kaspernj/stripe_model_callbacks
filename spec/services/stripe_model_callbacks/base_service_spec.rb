require "rails_helper"

describe StripeModelCallbacks::BaseService do
  let(:service_class) do
    Class.new(described_class) do
      attr_reader :event

      def initialize(event:)
        @event = event
      end

      def perform
        succeed!
      end
    end
  end
  let(:stripe_object) { instance_double(FakeStripeObject, object: "invoice", id: "in_123") }
  let(:stripe_data) { instance_double(FakeStripeEventData, object: stripe_object) }
  let(:stripe_event) { instance_double(FakeStripeEvent, data: stripe_data) }

  before do
    stub_const("FakeStripeObject", Struct.new(:object, :id))
    stub_const("FakeStripeEventData", Struct.new(:object))
    stub_const("FakeStripeEvent", Struct.new(:data))
  end

  it "acquires an advisory lock with a timeout" do
    expect(StripeModelCallbacks::ApplicationRecord).to receive(:with_advisory_lock!)
      .with("stripe-invoice-id-in_123", timeout_seconds: 10)
      .and_yield

    expect { service_class.execute_with_advisory_lock!(event: stripe_event) }.not_to raise_error
  end
end
