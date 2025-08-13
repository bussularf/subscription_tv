class Invoice < ApplicationRecord
  belongs_to :booklet
  has_many :accounts, dependent: :destroy
end
