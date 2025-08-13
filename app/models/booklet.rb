class Booklet < ApplicationRecord
  belongs_to :subscription
  has_many :invoices, dependent: :destroy
end
