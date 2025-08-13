class Account < ApplicationRecord
  belongs_to :billable, polymorphic: true
  belongs_to :invoice

  validates :due_date, :value, presence: true
end
