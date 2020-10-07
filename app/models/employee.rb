class Employee < ApplicationRecord
    has_paper_trail
    
    validates_presence_of :last_name, :employed_from
    validate :employed_to_or_currently_employed


    def employed_to_or_currently_employed
        unless currently_employed || employed_to
            errors.add(:base, "Currently employed and finish date can't both be blank")
        end
        if currently_employed && employed_to
            errors.add(:base, "Current employees can't have a finish date")
        end
    end

end
