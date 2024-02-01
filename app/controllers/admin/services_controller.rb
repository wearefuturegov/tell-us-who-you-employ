require 'service'

class Admin::ServicesController < Admin::BaseController
include Sortable

  def index
    @filterrific_params = params[:filterrific] || {}
    @services = Service.includes(:employees)
    @filterrific = initialize_filterrific(
      Service,
      @filterrific_params,
      select_options: {
        service: Service.options_for_service,
        location: Service.options_for_location
      },
      available_filters: [
        :service,
        :location,
        :search,
      ],
      persistence_id: 'false',
    ) or return
    @services = @filterrific.find
    @services = apply_sort(@services, params, 'name', %w[name employees_count full_address])
    @services = @services.page(params[:page]).per(20)
    
  end

  def show
    @service = Service.find(params[:id])

    @filterrific_params = params[:filterrific] || {}
    @filterrific = initialize_filterrific(
      @service.employees,
      @filterrific_params,
      select_options: {
        job_title: Employee.options_for_job_title,
        status: Employee.options_for_status,
        qualifications: Employee.options_for_qualifications,
        service: Employee.options_for_service
      },
      available_filters: [
        :job_title,
        :status,
        :qualifications,
        :service,
        :search,
      ],
      persistence_id: 'false',
    ) or return
    @employees = @filterrific.find
    @employees = apply_sort(@employees, params, 'forenames', %w[forenames surname job_title service_name])
    @employees = @employees.page(params[:page]).per(20)
  end
  
end