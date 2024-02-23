class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create

    # user info
    org_id = auth_hash.extra.raw_info.organisation_id
    services = auth_hash.extra.raw_info.organisation&.services
    first_name = auth_hash.extra.raw_info.first_name
    last_name = auth_hash.extra.raw_info.last_name

    # role info
    readonly_admin = auth_hash.extra.raw_info.admin || false
    admin_users = auth_hash.extra.raw_info.admin_users || false

    # user session info
    session[:organisation_id] = org_id
    session[:services] = services
    session[:uid] = auth_hash.uid
    session[:first_name] = first_name
    session[:last_name] = last_name
    persist_services_from_session if session[:services].present?

    # role session info
    session[:admin] = readonly_admin
    session[:admin_users] = admin_users
    
    if readonly_admin === true
      redirect_to admin_start_path
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
      service.save
  
    end
  end
end
