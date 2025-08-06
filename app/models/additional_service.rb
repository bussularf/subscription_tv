class AdditionalService < ApplicationRecord
  validates :name, presence: true
  validates :value, presence: true, numericality: true
  has_and_belongs_to_many :packages
end
