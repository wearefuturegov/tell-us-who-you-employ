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
    superadmin = auth_hash.extra.raw_info.superadmin || false

    # set user session info
    session[:organisation_id] = org_id
    session[:services] = services
    session[:uid] = auth_hash.uid
    session[:first_name] = first_name
    session[:last_name] = last_name
  



    # service info
    persist_services_from_session if session[:services].present?

    # role session info
    session[:admin] = readonly_admin
    session[:admin_users] = admin_users
    session[:superadmin] = superadmin
    
    if readonly_admin === true
      # set the access token
      # @TODO methods to refresh this
      auth = request.env['omniauth.auth']
      session[:access_token] = auth['credentials']['token']
    end

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

  # we save the services in here so that we don't have to query outpost in the admin section
  # each time someone logs in to update the service the service name will be updated from their session
  # nb theres no guarantee that the services will have the same name in the future though
  # so we're also saving the current service name in the paper_trail as well
  # theres no point tracking name changes for services since outpost holds all that data already
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
