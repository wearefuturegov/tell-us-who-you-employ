require 'service'

class Admin::ServicesController < Admin::BaseController
  def index

    @filterrific = initialize_filterrific(
      Service.with_last_employee_update,
      params[:filterrific],
      persistence_id: false,
      select_options: {
        with_service_id: Service.options_for_service,
        with_employee_count_range: Service.options_for_number_of_staff,
        sorted_by: Service.options_for_sorted_by,
      },
    ) or return
    
    @services = @filterrific.find.page(params[:page]).per(20)

  end

  def show
    @service = Service.find(params[:id])
    @senco = @service.employees.where("roles @> ARRAY[?]::varchar[]", ["Designated SENCO"]).first
    @safeguarding_lead = @service.employees.where("roles @> ARRAY[?]::varchar[]", ["Designated Safeguarding Lead"]).first

    @filterrific = initialize_filterrific(
      @service.employees,
      params[:filterrific],
      persistence_id: false,
      select_options: {
        job_title: Employee.options_for_job_title,
        status: Employee.options_for_status,
        qualifications: Employee.options_for_qualifications,
        with_service_id: Service.options_for_service,
        sorted_by: Employee.options_for_sorted_by,
      },
      available_filters: [
        :job_title,
        :status,
        :qualifications,
        # :service,
        :search,
        :sorted_by
      ],
    ) or return
    
    @employees = @filterrific.find.page(params[:page]).includes(:service).per(20)
  end
  
end