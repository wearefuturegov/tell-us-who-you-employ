class Service < ApplicationRecord


  # ----------
  # validations
  # ----------


 # ----------
  # associations
  # ----------
  has_many :employees
  attribute :name, :string


  # ----------
  # callbacks
  # ----------



  # ----------
  # search
  # ----------

  include PgSearch::Model
  pg_search_scope :search,
    against: [:name],
    using: {
      tsearch: { prefix: true }
    }

  # ----------
  # scopes
  # ----------

  scope :sorted_by, ->(sort_option) {
    direction = /desc$/.match?(sort_option) ? "desc" : "asc"
    services = Service.arel_table
    case sort_option.to_s
    when /^employee_updated_at_/
      with_employee_info.reorder("last_employees_update #{direction}")
    when /^service_/
      with_employee_info.reorder("LOWER(services.name) #{direction}")
    when /^staff_count_/
      with_employee_info.reorder("employee_count #{direction}")
    else
      raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
    end
  }

  scope :with_service_id, ->(service_ids) {
    where(id: [*service_ids])
  }
  
  scope :with_employee_count_range, ->(range_key) {
    where(id: Service.select("services.id")
                     .joins(:employees)
                     .group("services.id")
                     .having(employee_count_condition_subquery(range_key)))
  }

  # gets employee count + last employee updated date for each service
  scope :with_employee_info, -> {
    select('services.*, COUNT(employees.id) AS employee_count, MAX(employees.updated_at) AS last_employees_update')
    .joins(:employees)
    .group('services.id')
    .having('MAX(employees.updated_at) IS NOT NULL')
    .order('last_employees_update DESC')
  }


  # gets the last updated employee date for each service
  scope :with_last_employee_update, -> {
    select('services.*, MAX(employees.updated_at) AS last_employees_update')
    .joins(:employees)
    .group('services.id')
    .having('MAX(employees.updated_at) IS NOT NULL')
    .order('last_employees_update DESC')
  }

  # gets the total number of employees for each service
  scope :with_employee_count, -> {
    select('services.*, COUNT(employees.id) AS employee_count')
    .joins(:employees)
    .group('services.id')
  }
 

  # ----------
  # filtering
  # ----------

  filterrific(
    default_filter_params: { sorted_by: "employee_updated_at_desc"  },
    available_filters: [
      :with_service_id,
      :with_employee_count_range,
      :search,
      :sorted_by,
    ]
  )

  # ----------
  # filter options
  # ----------


  def self.options_for_service
    Service.distinct.order("name ASC").pluck(:id, :name).map(&:reverse)
  end

  def self.options_for_number_of_staff
    {
      '0-5' => '0-5',
      '6-10' => '6-10',
      '10-20' => '10-20',
      '20+' => '20+'
    }
  end

  def self.employee_count_condition_subquery(range_key)
    case range_key
    when '0-5'
      "COUNT(employees.id) BETWEEN 0 AND 5"
    when '6-10'
      "COUNT(employees.id) BETWEEN 6 AND 10"
    when '10-20'
      "COUNT(employees.id) BETWEEN 11 AND 20"
    when '20+'
      "COUNT(employees.id) > 20"
    else
      "1=1"
    end
  end


  def self.options_for_sorted_by
    [
      ["Most recently staff updated", "employee_updated_at_desc"],
      ["Least recently staff updated", "employee_updated_at_asc"],
      ["Provider A-Z", "service_asc"],
      ["Provider Z-A", "service_desc"],
      ["Number of staff 0-9", "staff_count_asc"],
      ["Number of staff 9-0", "staff_count_desc"],
    ]
  end

end