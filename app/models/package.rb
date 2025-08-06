class Package < ApplicationRecord
  belongs_to :plan
  has_and_belongs_to_many :additional_services

  validates :name, presence: true
  validates :plan, presence: true
  validates :value, presence: true
end
