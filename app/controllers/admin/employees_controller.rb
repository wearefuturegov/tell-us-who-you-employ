class Admin::EmployeesController < Admin::BaseController
  include ApplicationHelper
  def index
    @filterrific_params = params[:filterrific] || {}
    @original_search_term = @filterrific_params[:search]
    preprocess_search_parameter(@filterrific_params)
    @filterrific = initialize_filterrific(
      Employee,
      @filterrific_params,
      select_options: {
        job_title: Employee.options_for_job_title,
        status: Employee.options_for_status,
        qualifications: Employee.options_for_qualifications,
        provider: Employee.options_for_provider,
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

  private

  def preprocess_search_parameter(filterrific_params)
    if filterrific_params[:search].present?
      service_id = service_id_by_name(filterrific_params[:search])
      filterrific_params[:search] = service_id.to_s if service_id.present?
    end
  end
end
