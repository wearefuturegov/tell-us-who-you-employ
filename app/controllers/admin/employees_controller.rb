class Admin::EmployeesController < Admin::BaseController

  def index
    @filterrific = initialize_filterrific(
      Employee,
      params[:filterrific],
      select_options: {
        with_job_title: Employee.options_for_job_title,
        with_status: Employee.options_for_status,
        with_qualifications: Employee.options_for_qualifications,
        with_provider: Employee.options_for_provider,
      },
      available_filters: [
        :with_job_title,
        :with_status,
        :with_qualifications,
        :with_provider,
        :with_search,
      ],
      persistence_id: 'employees_filter',
    ) or return

    @employees = @filterrific.find.page(params[:page])
  end

  
end
