class StripeModelCallbacks::BaseService < ServicePattern::Service
  def self.reported_execute!(*args, &blk)
    with_exception_notifications do
      response = execute!(*args, &blk)
      raise response.errors.join(". ") unless response.success?
      return response
    end
  end

  def self.with_exception_notifications
    yield
  rescue => e # rubocop:disable Style/RescueStandardError
    Rails.logger.error "ERROR: #{e.message}"

    cleaned = Rails.backtrace_cleaner.clean(e.backtrace)
    if cleaned.any?
      Rails.logger.error cleaned
    else
      Rails.logger.error e.backtrace.join("\n")
    end

    ExceptionNotifier.notify_exception(e) if Rails.env.production?
  end
end
