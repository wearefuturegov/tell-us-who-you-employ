class Admin::EmployeesController < Admin::BaseController
  include ApplicationHelper
  def index
    @filterrific_params = params[:filterrific] || {}
    transformed_search_term = transform_search_term(@filterrific_params[:search])
    services = session[:services] || []
    @filterrific = initialize_filterrific(
      Employee,
      @filterrific_params.merge(search: transformed_search_term),
      select_options: {
        job_title: Employee.options_for_job_title,
        status: Employee.options_for_status,
        qualifications: Employee.options_for_qualifications,
        provider: Employee.options_for_provider(services),
      },
      available_filters: [
        :job_title,
        :status,
        :qualifications,
        :provider,
        :search,
      ],
      persistence_id: 'false',
    ) or return
    
    @employees = @filterrific.find
    @employees = apply_sort(@employees)
    @employees = @employees.page(params[:page])
  end

  def show
    @employee = Employee.find(params[:id])
  end

  private

  def transform_search_term(search_term)
    return search_term unless search_term.present?
    service_id = service_id_by_name(search_term, session[:services])
    service_id ? service_id.to_s : search_term
  end


  def apply_sort(employees)
    if params[:sort] && params[:direction]
      sort_column = allowed_sort_columns.include?(params[:sort]) ? params[:sort] : 'default_column'
      sort_direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
      employees.order("#{sort_column} #{sort_direction}")
    else
      employees
    end
  end

  def allowed_sort_columns
    %w[forenames surname job_title]
  end
end
