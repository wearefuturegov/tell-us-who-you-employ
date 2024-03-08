class Duplicate < ApplicationRecord
  belongs_to :employee, foreign_key: :employee_id

  validates_presence_of :employee_id
  validates_presence_of :is_duplicate
end
