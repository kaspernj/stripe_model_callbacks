class StripeModelCallbacks::Subscription::StateCheckerService < StripeModelCallbacks::BaseService
  attr_reader :allowed, :state

  def initialize(allowed:, state:)
    @allowed = allowed
    @state = state.to_s
  end

  def execute
    if state.is_a?(Array)
      state.each do |state_i|
        response = Subscription::StateCheckerService.execute!(allowed: allowed, state: state_i)
        return response unless response.success?
      end
    elsif !allowed.include?(state)
      return fail! ["Not allowed: #{state}"]
    end

    succeed!
  end
end
