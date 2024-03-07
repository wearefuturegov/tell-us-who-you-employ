class Employee < ApplicationRecord
  has_paper_trail(
    meta: {
      service_id: :service_id
    }
  )


  # ----------
  # validations
  # ----------
  attr_accessor :skip_validations
  validates_presence_of :surname, :forenames, :employed_from, :date_of_birth, :street_address, :postal_code, :job_title, unless: :skip_validations
  validate :employed_to_or_currently_employed, :has_food_hygiene_qualification_or_achieved_on, :has_dbs_check_or_achieved_on, :has_first_aid_training_or_achieved_on, :has_senco_or_achieved_on, :has_senco_early_years_or_achieved_on, :has_safeguarding_or_achieved_on, unless: :skip_validations
  validates :job_title, inclusion: { in: :accepted_job_titles, message: "%{value} is not a valid job title" }, unless: :skip_validations

  def accepted_job_titles 
    [
      "Acting Deputy Manager/Leader/Supervisor",
      "Acting Manager/Leader/Supervisor",
      "Apprentice/Intern",
      "Assistant Childminder",
      "Chair Person",
      "Childminder",
      "Cleaner/Caretaker/Catering",
      "Deputy Manager/Leader/Supervisor",
      "Finance/Administrator/Secretary",
      "Lead Practitioner",
      "Manager/Leader/Supervisor",
      "Nanny",
      "Not Applicable",
      "Nursery/Pre-School Assistant",
      "On Maternity Leave",
      "Owner/Proprietor/Director",
      "Playworker",
      "Room Leader/Supervisor",
      "Treasurer",
      "Volunteer"
    ]
  end


  def accepted_roles
    [
      "Designated Behaviour Management Lead",
      "Designated Safeguarding Lead",
      "Designated SENCO",
      "First Aider",
      "Ofsted Registered Contact",
      "Practice Leader"    
    ]
  end


  def accepted_qualifications
    [
      "Level 2",
      "Level 3",
      "Level 4",
      "Level 5",
      "Level 6",
      "EYPS",
      "QTS",
      "EYC"
    ]
  end


  # ----------
  # associations
  # ----------
  belongs_to :service, touch: true


  # ----------
  # callbacks
  # ----------



  # ----------
  # search
  # ----------

  
  include PgSearch::Model
  pg_search_scope :search, 
    against: [:forenames, :surname, :job_title, :qualifications, :service_id],
    associated_against: {
      service: [:name]
    }, 
    using: {
      trigram: { threshold: 0.1},
      tsearch: { prefix: true }
    }



  # ----------
  # scopes
  # ----------
  default_scope { where(marked_for_deletion: nil) }

  scope :sorted_by, ->(sort_option) {
    direction = /desc$/.match?(sort_option) ? "desc" : "asc"
    employees = Employee.arel_table
    services = Service.arel_table
    case sort_option.to_s
    when /^updated_at_/
      order(employees[:updated_at].send(direction)) 
    when /^forenames_/
      order(employees[:forenames].lower.send(direction))
    when /^surname_/
      order(employees[:surname].lower.send(direction))
    when /^job_title_/
      order(employees[:job_title].lower.send(direction))
    when /^service_/
      joins(:service).order(services[:name].send(direction))
    when /^status_/
      order(employees[:currently_employed].send(direction))
    when /^created_at_/
      order(employees[:created_at].send(direction)) 
    else
      raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
    end
  }

  scope :with_service_id, ->(service_ids) {
    where(id: [*service_ids]) if service_ids
  }


  scope :job_title, -> (job_title) {
    where(job_title: job_title)
  }
  
  scope :status, -> (status) {
    case status
    when 'inactive'
      where(currently_employed: false)
    when 'active'
      where(currently_employed: true)
    else
      raise(ArgumentError, "Invalid status: #{status}")
    end
  }

  scope :qualifications, -> (selected_qualifications) {
    where("qualifications && ARRAY[?]::varchar[]", Array(selected_qualifications))
  }
  
  # ----------
  # filtering
  # ----------

  filterrific(
    default_filter_params: { sorted_by: "updated_at_desc" },
    available_filters: [
      :job_title,
      :status,
      :qualifications,
      :with_service_id,
      :search,
      :sorted_by
    ]
  )



  # ----------
  # filter options
  # ----------

  def self.order_by_roles(direction = 'asc')
    sort_direction = ['asc', 'desc'].include?(direction.downcase) ? direction.downcase : 'asc'
    order_query = Arel.sql("CASE WHEN array_length(roles, 1) IS NULL THEN 0 ELSE array_length(roles, 1) END #{sort_direction}")
    order(order_query)
  end

  def self.options_for_status 
    [
      ['Active', 'active'],
      ['Inactive', 'inactive']
    ]
  end

  def self.options_for_job_title 
    [
      ['Acting Deputy Manager/Leader/Supervisor', 'Acting Deputy Manager/Leader/Supervisor'],
      ['Acting Manager/Leader/Supervisor', 'Acting Manager/Leader/Supervisor'],
      ['Apprentice/Intern', 'Apprentice/Intern'],
      ['Assistant Childminder', 'Assistant Childminder'],
      ['Chair Person', 'Chair Person'],
      ['Childminder', 'Childminder'],
      ['Cleaner/Caretaker/Catering', 'Cleaner/ Caretaker/Catering'],
      ['Deputy Manager/Leader/Supervisor', 'Deputy Manager/Leader/Supervisor'],
      ['Finance/Administration/Secretary', 'Finance/Administration/Secretary'],
      ['Lead Practitioner', 'Lead Practitioner'],
      ['Manager/Leader/Supervisor', 'Manager/Leader/Supervisor'],
      ['Nanny', 'Nanny'],
      ['Not Applicable', 'Not Applicable'],
      ['Nursery/Pre-School Assistant', 'Nursery/Pre-School Assistant'],
      ['On maternity leave', 'On maternity leave'],
      ['Owner/Proprietor/Director', 'Owner/Proprietor/Director'],
      ['Playworker', 'Playworker'],
      ['Room Leader/Supervisor', 'Room Leader/Supervisor'],
      ['Treasurer', 'Treasurer'],
      ['Volunteer', 'Volunteer']
    ]
  end

  def self.options_for_qualifications
    [
      ['Level 2', 'Level 2'],
      ['Level 3', 'Level 3'],
      ['Level 4', 'Level 4'],
      ['Level 5', 'Level 5'],
      ['Level 6', 'Level 6'],
      ['EYPS', 'EYPS'],
      ['QTS', 'QTS'],
      ['EYC', 'EYC'],
    ]
  end

  def self.options_for_sorted_by
    [
      ["Most recently updated", "updated_at_desc"],
      ["Least recently updated", "updated_at_asc"],
      ["Oldest added", "created_at_asc"],
      ["Newest added", "created_at_desc"],
      ["Forename A-Z", "forenames_asc"],
      ["Forename Z-A", "forenames_desc"],
      ["Surname A-Z", "surname_asc"],
      ["Surname Z-A", "surname_desc"],
      ["Job title A-Z", "job_title_asc"],
      ["Job title Z-A", "job_title_desc"],
      ["Provider A-Z", "service_desc"],
      ["Provider Z-A", "service_asc"],
      ["Status A-Z", "status_desc"],
      ["Status Z-A", "status_asc"],
    ]
  end




  # ----------
  # deletion
  # ----------

  def soft_delete
    update(marked_for_deletion: Time.current, currently_employed: false, employed_to: Time.current)
  end

  def restore
    update(marked_for_deletion: nil)
  end



  # ----------
  # Error checking
  # ----------



  def employed_to_or_currently_employed
    unless currently_employed || employed_to
      errors.add(:base, "Currently employed and finish date can't both be blank")
    end
    if currently_employed && employed_to
      errors.add(:base, "Current employees can't have a finish date")
    end
    if employed_to && employed_to.before?(employed_from)
      errors.add(:base, "The employment finish date shouldn't be before the start date")
    end
    if employed_from && employed_from.after?(Time.now)
      errors.add(:base, "The employment start date can't be in future")
    end
    if employed_to && employed_to.after?(Time.now)
      errors.add(:base, "The employment end date can't be in future")
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
