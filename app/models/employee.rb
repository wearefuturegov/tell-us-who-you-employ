class Employee < ApplicationRecord
  has_paper_trail

  attr_accessor :skip_validations
  validates_presence_of :surname, :forenames, :employed_from, :date_of_birth, :street_address, :postal_code, :job_title, unless: :skip_validations
  validate :employed_to_or_currently_employed, :has_food_hygiene_qualification_or_achieved_on, :has_dbs_check_or_achieved_on, :has_first_aid_training_or_achieved_on, :has_senco_or_achieved_on, :has_senco_early_years_or_achieved_on, :has_safeguarding_or_achieved_on, unless: :skip_validations

  def employed_to_or_currently_employed
    unless currently_employed || employed_to
      errors.add(:base, "Currently employed and finish date can't both be blank")
    end
    if currently_employed && employed_to
      errors.add(:base, "Current employees can't have a finish date")
    end
    if employed_to && employed_from > employed_to
      errors.add(:base, "Employment start date can't be before finish date")
    end
    if employed_from && employed_from > Time.now
      errors.add(:base, "Employment start date can't be in future")
    end
    if employed_to && employed_to > Time.now
      errors.add(:base, "Employment end date can't be in future")
    end
  end

  def has_food_hygiene_qualification_or_achieved_on
    if (has_food_hygiene && !food_hygiene_achieved_on)
      errors.add(:base, "Please add the date this person achieved food hygiene training")
    elsif (!has_food_hygiene && food_hygiene_achieved_on)
      errors.add(:base, "Please tick food hygiene training field or remove the date achieved")
    end
  end

  def has_dbs_check_or_achieved_on
    if (has_dbs_check && !dbs_achieved_on)
      errors.add(:base, "Please add the date this person achieved DBS check")
    elsif (!has_dbs_check && dbs_achieved_on)
      errors.add(:base, "Please tick DBS check field or remove the date achieved")
    end
  end

  def has_first_aid_training_or_achieved_on
    if (has_first_aid_training && !first_aid_achieved_on)
      errors.add(:base, "Please add the date this person achieved Paediatric first aid training")
    elsif (!has_first_aid_training && first_aid_achieved_on)
      errors.add(:base, "Please tick Paediatric first aid training field or remove the date achieved")
    end
  end

  def has_senco_or_achieved_on
    if (has_senco_training && !senco_achieved_on)
      errors.add(:base, "Please add the date this person achieved SENCO training")
      elsif (!has_senco_training && senco_achieved_on)
        errors.add(:base, "Please tick SENCO training field or remove the date achieved")
    end
  end

  def has_senco_early_years_or_achieved_on
    if (has_senco_early_years && !senco_early_years_achieved_on)
      errors.add(:base, "Please add the date this person achieved Early years level 3 SENCO")
    elsif (!has_senco_early_years && senco_early_years_achieved_on)
      errors.add(:base, "Please tick Early years level 3 SENCO field or remove the date achieved")
    end
  end

  def has_safeguarding_or_achieved_on
    if (has_safeguarding && !safeguarding_achieved_on)
      errors.add(:base, "Please add the date this person achieved Safeguarding training")
      elsif (!has_safeguarding && safeguarding_achieved_on)
        errors.add(:base, "Please tick Safeguarding training field or remove the date achieved")
    end
  end

end
