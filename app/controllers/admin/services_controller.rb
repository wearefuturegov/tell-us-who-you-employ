require 'service'

class Admin::ServicesController < Admin::BaseController
  include Sortable

  def index
    initial_scope = Service.where(organisation_id: session[:organisation_id].presence).includes(:employees)
    @filterrific = initialize_filterrific(
      initial_scope,
      params[:filterrific],
      select_options: {
        service: Service.options_for_service(session[:organisation_id]),
        location: Service.options_for_location
      },
      persistence_id: 'false',
    ) or return
    @services = @filterrific.find
    @services = apply_sort(@services, params, 'name', %w[name employees_count full_address])
    @services = @services.page(params[:page]).per(20)
    
  end

  def show
    @service = Service.where(organisation_id: session[:organisation_id], id: params[:id]).first
    @senco = @service.employees.where("roles @> ARRAY[?]::varchar[]", ["Designated SENCO"]).first
    @safeguarding_lead = @service.employees.where("roles @> ARRAY[?]::varchar[]", ["Designated Safeguarding Lead"]).first
    @filterrific = initialize_filterrific(
      @service.employees.where(organisation_id: session[:organisation_id].presence),
      params[:filterrific],
      select_options: {
        job_title: Employee.options_for_job_title,
        status: Employee.options_for_status,
        qualifications: Employee.options_for_qualifications,
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
    @employees = apply_sort(@employees, params, 'forenames', %w[forenames surname job_title roles qualifications status])
    @employees = @employees.page(params[:page]).per(20)
  end
  
end