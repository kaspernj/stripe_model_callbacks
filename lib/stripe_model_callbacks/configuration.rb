class StripeModelCallbacks::Configuration
  def self.current
    @configuration ||= StripeModelCallbacks::Configuration.new
  end

  def initialize
    @on_error_callbacks = []
  end

  def on_error(&blk)
    @on_error_callbacks << blk
  end

  def with_error_handling(args: nil)
    yield
  rescue => error
    @on_error_callbacks.each do |callback|
      callback(args: args, error: error)
    end

    raise error
  end
end
