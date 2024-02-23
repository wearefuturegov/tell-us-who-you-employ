class DuplicateRecord < ApplicationRecord
  belongs_to :employee1, class_name: 'Employee', foreign_key: 'employee1_id'
  belongs_to :employee2, class_name: 'Employee', foreign_key: 'employee2_id'

  validates :employee1_id, :employee2_id, presence: true
end
