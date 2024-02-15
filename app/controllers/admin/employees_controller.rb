class Admin::EmployeesController < Admin::BaseController
  def index
    @filterrific_params = params[:filterrific] || {}
    @employees = Employee.includes(:service)
    @filterrific = initialize_filterrific(
      Employee,
      @filterrific_params,
      select_options: {
        sorted_by: Employee.options_for_sorted_by,
        job_title: Employee.options_for_job_title,
        status: Employee.options_for_status,
        qualifications: Employee.options_for_qualifications,
        service: Employee.options_for_service(),
      },
      persistence_id: false,
    ) or return
    
    @employees = @filterrific.find.page(params[:page]).per(20)
  end

  def show
    @employee = Employee.find(params[:id])
  end

end
