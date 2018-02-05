class StripeModelCallbacks::ApplicationRecord < ActiveRecord::Base
  include PublicActivity::Model
  tracked

  self.abstract_class = true
end
