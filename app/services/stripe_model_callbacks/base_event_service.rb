class StripeModelCallbacks::BaseEventService < ServicePattern::Service
  attr_reader :event

  def self.reported_execute!(*args, &blk)
    with_exception_notifications do
      response = execute!(*args, &blk)
      raise response.errors.join(". ") unless response.success?
      return response
    end
  end

  def self.with_exception_notifications
    yield
  rescue => e
    puts "ERROR: #{e.message}"

    cleaned = Rails.backtrace_cleaner.clean(e.backtrace)
    if cleaned.any?
      puts cleaned
    else
      puts e.backtrace
    end

    # ExceptionNotifier.notify_exception(e)
  end

  def initialize(event:)
    @event = event
  end

  def object
    event.data.object
  end
end
