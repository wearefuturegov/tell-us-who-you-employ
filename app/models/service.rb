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
    default_filter_params: {},
    available_filters: [
      :search,
      :service,
      :location
    ]
  )

  scope :service, -> (service) {where(name: service)}

  scope :location, -> (location) {
    where("CONCAT_WS(', ', location_name, address_1, city, postal_code) = ?", location) unless location.blank?
  }

  def full_address
    [location_name, address_1, city, postal_code].compact.join(', ')
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