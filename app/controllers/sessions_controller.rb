class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    # First check that the user is associated to an organisation and has listed
    # services; if they haven't, they can't use this service
    org_id = auth_hash.extra.raw_info.organisation_id
    services = auth_hash.extra.raw_info.organisation&.services
    readonly_admin = auth_hash.extra.raw_info.admin || false
    admin_users = auth_hash.extra.raw_info.admin_users || false
    first_name = auth_hash.extra.raw_info.first_name
    last_name = auth_hash.extra.raw_info.last_name

    if readonly_admin === false
      if org_id.nil? || services.empty?
        redirect_to root_path, alert: "It looks like you haven't listed any services yet, please list your services on our directory before you begin"
        return
      end
    end

    session[:organisation_id] = org_id
    session[:services] = services
    session[:uid] = auth_hash.uid
    session[:name] = 
    persist_services_from_session if session[:services].present?
    session[:admin] = readonly_admin
    session[:admin_users] = admin_users
    session[:first_name] = first_name
    session[:last_name] = last_name


    # @TODO create /admin path
    if readonly_admin === true
      redirect_to admin_employees_path
    else 
      redirect_to employees_path
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end

  def persist_services_from_session
    return unless session[:services].present?
  
    session[:services].each do |service_data|
      if service_data.respond_to?(:to_h)
        service_data = service_data.to_h
      end
      
      service = Service.find_or_initialize_by(id: service_data['id'])
      service.name = service_data['name']
  
    end
  end
end
