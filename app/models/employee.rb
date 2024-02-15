class Employee < ApplicationRecord
  has_paper_trail

  attr_accessor :skip_validations
  validates_presence_of :surname, :forenames, :employed_from, :date_of_birth, :street_address, :postal_code, :job_title, unless: :skip_validations
  validate :employed_to_or_currently_employed, :has_food_hygiene_qualification_or_achieved_on, :has_dbs_check_or_achieved_on, :has_first_aid_training_or_achieved_on, :has_senco_or_achieved_on, :has_senco_early_years_or_achieved_on, :has_safeguarding_or_achieved_on, unless: :skip_validations

  belongs_to :service
  
  include PgSearch::Model
  pg_search_scope :search, 
    against: [:forenames, :surname, :job_title, :qualifications, :service_id],
    associated_against: {
      service: [:name]
    }, 
    using: {
      tsearch: { prefix: true }
    }

  filterrific(
    default_filter_params: {sorted_by: 'forenames_asc'},
    available_filters: [
      :sorted_by,
      :search,
      :job_title,
      :status,
      :qualifications,
      :service
    ]
  )

  scope :job_title, -> (job_title) {where(job_title: job_title)}
  
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
  
  scope :service, -> (service_id) {
    where(service_id: service_id) if service_id
  }

  scope :sorted_by, -> (sort_option) {
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^forenames/
      order("employees.forenames #{direction}")
    when /^surname/
      order("employees.surname #{direction}")
    when /^job_title/
      order("employees.job_title #{direction}")
    when /^service_name/
      joins(:service).order("services.name #{direction}")
    when /^qualifications/
      order("employees.qualifications #{direction}")
    when /^status/
      order("employees.currently_employed #{direction}")
    when /^roles/
      order_by_roles(direction)
    else
      raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
    end
  }

  def self.options_for_sorted_by(include_roles: false)
    options = 
    [
      ['Forenames (a-z)', 'forenames_asc'],
      ['Forenames (z-a)', 'forenames_desc'],
      ['Surname (a-z)', 'surname_asc'],
      ['Surname (z-a)', 'surname_desc'],
      ['Job Title (a-z)', 'job_title_asc'],
      ['Job Title (z-a)', 'job_title_desc'],
    ]
    if include_roles
      options << ['Roles (least to most)', 'roles_asc']
      options << ['Roles (most to least)', 'roles_desc']
    else
      options << ['Service (a-z)', 'service_name_asc']
      options << ['Service (z-a)', 'service_name_desc']
    end
    
    options << ['Qualifications (a-z)', 'qualifications_asc']
    options << ['Qualifications (z-a)', 'qualifications_desc']
    options << ['Status (a-z)', 'status_asc']
    options << ['Status (z-a)', 'status_desc']
      options
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

  def self.options_for_service()
    Employee.distinct.pluck(:service_id).map do |service_id|
      [Service.find(service_id).name, service_id]
    end
  end

  
  def self.order_by_roles(direction = 'asc')
    sort_direction = ['asc', 'desc'].include?(direction.downcase) ? direction.downcase : 'asc'
    order_query = Arel.sql("CASE WHEN array_length(roles, 1) IS NULL THEN 0 ELSE array_length(roles, 1) END #{sort_direction}")
    order(order_query)
  end

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
