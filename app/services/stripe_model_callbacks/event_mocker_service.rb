class StripeModelCallbacks::EventMockerService
  attr_reader :args, :name, :scope

  def self.execute!(args:, name:, scope:)
    new(args:, name:, scope:).perform
  end

  def initialize(args:, name:, scope:)
    @args = args
    @name = name
    @scope = scope
  end

  def perform
    bypass_event_signature(payload)
    post_event
  end

  def payload
    file_content = File.read(fixture_path)
    data = JSON.parse(file_content, symbolize_names: true)
    data.deep_merge!(args) if args
    data
  end

private

  def bypass_event_signature(payload)
    event = Stripe::Event.construct_from(payload)
    scope.expect(Stripe::Webhook).to scope.receive(:construct_event).and_return(event)
  end

  def first_part
    @first_part ||= name.split(".").first
  end

  def fixture_path
    @fixture_path ||= "#{__dir__}/../../../lib/stripe_model_callbacks/fixtures/stripe_events/#{first_part}/#{name}.json"
  end

  def post_event
    scope.post("/stripe-events", params: JSON.generate(payload))
  end
end
