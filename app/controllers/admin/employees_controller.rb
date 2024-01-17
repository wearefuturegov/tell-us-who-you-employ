class Admin::EmployeesController < Admin::BaseController

  def index
    @filterrific = initialize_filterrific(
      Employee,
      params[:filterrific],
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
    puts @employees.inspect
  end
end
