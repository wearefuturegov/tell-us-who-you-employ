class Employee < ApplicationRecord
    has_paper_trail
    
    validates_presence_of :last_name, :employed_from
end
