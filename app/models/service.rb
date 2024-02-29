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

  scope :service, -> (service) {where(name: service)}

  scope :sorted_by, ->(sort_option) {
    direction = /desc$/.match?(sort_option) ? "desc" : "asc"
    services = Service.arel_table
    case sort_option.to_s
    when /^service_/
      order(services[:name].lower.send(direction))
    # when /^staff_count_/
      # order(employees[:qualifications].lower.send(direction))
    else
      raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
    end
  }

  scope :with_employee_count_range, ->(range_key) {
    where(id: Service.select("services.id")
                     .joins(:employees)
                     .group("services.id")
                     .having(employee_count_condition_subquery(range_key)))
  }



  # ----------
  # filtering
  # ----------

  filterrific(
    default_filter_params: { },
    available_filters: [
      :search,
      :service,
      :sorted_by,
      :with_employee_count_range,
    ]
  )

    # ----------
  # filter options
  # ----------


  def self.options_for_service
    Service.distinct.pluck(:name).map do |service|
      [service, service]
    end
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

  # def self.options_for_location
  #   Service.find_each.map do |service|
  #     service.full_address
  #   end.uniq.sort.map do |service|
  #     [service, service]
  #   end
  # end


  def self.options_for_sorted_by
    [
      ["Provider A-Z", "service_asc"],
      ["Provider Z-A", "service_desc"]
      # ["Number of staff 0-9", "staff_count_asc"],
      # ["Number of staff 9-0", "staff_count_desc"],
    ]
  end

end