class Admin::EmployeesController < Admin::BaseController
  include ApplicationHelper
  def index
    @filterrific_params = params[:filterrific] || {}
    @original_search_term = @filterrific_params[:search]
    transformed_search_term = transform_search_term(@filterrific_params[:search])
    @filterrific_params[:search] = transformed_search_term if transformed_search_term
    services = session[:services] || []
    @filterrific = initialize_filterrific(
      Employee,
      @filterrific_params,
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
    
    @employees = @filterrific.find.page(params[:page])
  end

  def show
    @employee = Employee.find(params[:id])
  end

  private

  def transform_search_term(search_term)
    return nil unless search_term.present?
    service_id = service_id_by_name(search_term, session[:services])
    service_id ? service_id.to_s : search_term
  end
end
