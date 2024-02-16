require 'service'

class Admin::ServicesController < Admin::BaseController
  def index
    @filterrific_params = params[:filterrific] || {}
    @services = Service.includes(:employees)
    @filterrific = initialize_filterrific(
      Service,
      @filterrific_params,
      select_options: {
        sorted_by: Service.options_for_sorted_by,
        service: Service.options_for_service,
        location: Service.options_for_location
      },
      persistence_id: false,
    ) or return
    @services = @filterrific.find.page(params[:page]).per(20)
  end

  def show
    @include_roles = true
    @service = Service.find(params[:id])
    @senco = @service.employees.where("roles @> ARRAY[?]::varchar[]", ["Designated SENCO"]).first
    @safeguarding_lead = @service.employees.where("roles @> ARRAY[?]::varchar[]", ["Designated Safeguarding Lead"]).first
    @filterrific_params = params[:filterrific] || {}
    @filterrific = initialize_filterrific(
      @service.employees,
      @filterrific_params,
      select_options: {
        job_title: Employee.options_for_job_title,
        status: Employee.options_for_status,
        qualifications: Employee.options_for_qualifications,
        sorted_by: Employee.options_for_sorted_by(include_roles: @include_roles),
      },
      available_filters: [
        :job_title,
        :status,
        :qualifications,
        :service,
        :search,
        :sorted_by,
      ],
      persistence_id: false,
    ) or return
    @employees = @filterrific.find.page(params[:page]).per(20)
  end
  
end