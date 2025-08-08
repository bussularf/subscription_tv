class Subscription < ApplicationRecord
  belongs_to :customer
  belongs_to :plan, optional: true
  belongs_to :package, optional: true

  has_many :subscription_additional_services, dependent: :destroy
  has_many :additional_services

  accepts_nested_attributes_for :subscription_additional_services, allow_destroy: true
end
