# app/controllers/concerns/sortable.rb
module Sortable
  extend ActiveSupport::Concern

  def apply_sort(collection, sort_params, default_column, allowed_columns)
    sort_column = allowed_columns.include?(sort_params[:sort]) ? sort_params[:sort] : default_column
    sort_direction = %w[asc desc].include?(sort_params[:direction]) ? sort_params[:direction] : 'asc'

    case sort_column
    when 'employees_count'
      collection = collection.left_joins(:employees)
                              .group("#{collection.table_name}.id")
                              .select("#{collection.table_name}.*, COUNT(employees.id) as employees_count")
                              .order("employees_count #{sort_direction}")
    when 'service_name'
      collection = collection.joins(:service).order("services.name #{sort_direction}")
    when 'full_address'
      collection = collection.order_by_full_address(sort_direction)
    when 'roles'
    collection = collection.order_by_roles(sort_direction)
    when 'qualifications'
      collection = collection.order("qualifications #{sort_direction}")
    when 'status'
      collection = collection.order("currently_employed #{sort_direction}")
    else
      collection = collection.order("#{sort_column} #{sort_direction}")
    end

    collection
  end  
end
