class Admin::EmployeesController < Admin::BaseController
  include ApplicationHelper
  include Sortable
  def index
    @filterrific_params = params[:filterrific] || {}
    @employees = Employee.includes(:service)
    @filterrific = initialize_filterrific(
      Employee,
      @filterrific_params,
      select_options: {
        job_title: Employee.options_for_job_title,
        status: Employee.options_for_status,
        qualifications: Employee.options_for_qualifications,
        service: Employee.options_for_service(),
      },
      persistence_id: 'false',
    ) or return
    
    @employees = @filterrific.find
    @employees = apply_sort(@employees, params, 'forenames', %w[forenames surname job_title service_name])
    @employees = @employees.page(params[:page]).per(20)
  end

  def show
    @employee = Employee.find(params[:id])
  end

end
