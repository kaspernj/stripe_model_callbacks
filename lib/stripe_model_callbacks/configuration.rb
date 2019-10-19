class StripeModelCallbacks::Configuration
  def self.current
    @current ||= StripeModelCallbacks::Configuration.new
  end

  def initialize
    @on_error_callbacks = []
  end

  def on_error(&blk)
    @on_error_callbacks << blk
  end

  def with_error_handling(args: nil)
    yield
  rescue => e # rubocop:disable Style/RescueStandardError
    @on_error_callbacks.each do |callback|
      callback.call(args: args, error: e)
    end

    raise e
  end
end
