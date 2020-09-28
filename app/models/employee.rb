class Employee < ApplicationRecord
    validates_presence_of :last_name, :employed_from
end
