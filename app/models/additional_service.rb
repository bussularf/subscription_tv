class AdditionalService < ApplicationRecord
  validates :name, presence: true
  validates :value, presence: true, numericality: true
end
