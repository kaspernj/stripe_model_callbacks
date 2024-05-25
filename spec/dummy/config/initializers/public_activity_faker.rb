Rails.application.reloader.to_prepare do
  StripeModelCallbacks::ApplicationRecord.class_eval do
    after_create :log_create_activity
    after_update :log_update_activity

    def create_activity(key)
      Activity.create!(key: "#{model_name.singular}.#{key}", trackable: self)
    end

    def log_create_activity
      Activity.create!(key: "#{model_name.singular}.create", trackable: self)
    end

    def log_update_activity
      Activity.create!(key: "#{model_name.singular}.update", trackable: self)
    end
  end
end
