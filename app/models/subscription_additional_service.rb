class SubscriptionAdditionalService < ApplicationRecord
  belongs_to :subscription
  belongs_to :additional_service
end
