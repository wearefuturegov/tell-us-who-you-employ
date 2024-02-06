class Admin::EmployeesController < Admin::BaseController
  include ApplicationHelper
  include Sortable
  def index
    initial_scope = Employee.includes(:service).where(organisation_id: session[:organisation_id].presence)
    @filterrific = initialize_filterrific(
      initial_scope,
      params[:filterrific],
      select_options: {
        job_title: Employee.options_for_job_title,
        status: Employee.options_for_status,
        qualifications: Employee.options_for_qualifications,
        service: Employee.options_for_service(session[:organisation_id]),
      },
      persistence_id: 'false',
    ) or return
    
    @employees = @filterrific.find
    @employees = apply_sort(@employees, params, 'forenames', %w[forenames surname job_title service_name qualifications status])
    @employees = @employees.page(params[:page]).per(20)
  end

  def show
    @employee = Employee.where(organisation_id: session[:organisation_id], id: params[:id]).first
  end

end
