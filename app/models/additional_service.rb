class AdditionalService < ApplicationRecord
  validates :name, presence: true
  validates :value, presence: true, numericality: true

  has_and_belongs_to_many :packages

  has_many :subscription_additional_services
  has_many :subscriptions, through: :subscription_additional_services
end
