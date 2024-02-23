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
    when /^staff_count_/
      # order(employees[:qualifications].lower.send(direction))
    else
      raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
    end
  }



  # ----------
  # filtering
  # ----------

  filterrific(
    default_filter_params: { },
    available_filters: [
      :search,
      :service,
      :sorted_by
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


  def self.options_for_location
    Service.find_each.map do |service|
      service.full_address
    end.uniq.sort.map do |service|
      [service, service]
    end
  end


  def self.options_for_sorted_by
    [
      ["Provider A-Z", "service_asc"],
      ["Provider Z-A", "service_desc"]
      # ["Number of staff 0-9", "staff_count_asc"],
      # ["Number of staff 9-0", "staff_count_desc"],
    ]
  end



  # ----------
  # other
  # ----------

  def full_address
    [location_name, address_1, city, postal_code].compact.join(', ')
  end



  def self.order_by_full_address(direction = 'asc')
    location_name = arel_table[:location_name]
    address_1 = arel_table[:address_1]
    order_query = Arel::Nodes::NamedFunction.new('COALESCE', [location_name, address_1])
                    .send(direction == 'asc' ? :asc : :desc)
    order(order_query)
  end

end