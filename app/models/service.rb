class Service < ApplicationRecord

  has_many :employees

  attribute :location_name, :string
  attribute :address_1, :string
  attribute :city, :string
  attribute :postal_code, :string

  attribute :name, :string


include PgSearch::Model
  pg_search_scope :search,
    against: [:name, :location_name, :address_1, :city, :postal_code],
    using: {
      tsearch: { prefix: true }
    }

  filterrific(
    default_filter_params: {sorted_by: 'name_asc'},
    available_filters: [
      :sorted_by,
      :search,
      :service,
      :location
    ]
  )

  scope :sorted_by, -> (sort_option) {
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^name/
      order("services.name #{direction}")
    when /^location/
      order_by_full_address(direction)
    when /^employees_count/
      left_joins(:employees)
        .group("services.id")
        .order("COUNT(employees.id) #{direction}")
    else
      raise(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
    end
  }

  scope :service, -> (service) {where(name: service)}

  scope :location, -> (location) {
    where("CONCAT_WS(', ', location_name, address_1, city, postal_code) = ?", location) unless location.blank?
  }

  def full_address
    [location_name, address_1, city, postal_code].compact.join(', ')
  end

  def self.options_for_sorted_by
    [
      ['Name (a-z)', 'name_asc'],
      ['Name (z-a)', 'name_desc'],
      ['Location (a-z)', 'location_asc'],
      ['Location (z-a)', 'location_desc'],
      ['Employees (most to least)', 'employees_count_desc'],
      ['Employees (least to most)', 'employees_count_asc']
    ]
  end

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

  def self.order_by_full_address(direction = 'asc')
    location_name = arel_table[:location_name]
    address_1 = arel_table[:address_1]
    order_query = Arel::Nodes::NamedFunction.new('COALESCE', [location_name, address_1])
                    .send(direction == 'asc' ? :asc : :desc)
    order(order_query)
  end

end