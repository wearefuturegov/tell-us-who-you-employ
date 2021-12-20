class SessionsController < ApplicationController
  def create
    # First check that the user is associated to an organisation and has listed
    # services; if they haven't, they can't use this service
    org_id = auth_hash.extra.raw_info.organisation_id
    services = auth_hash.extra.raw_info.organisation&.services

    if org_id.nil? || services.empty?
      redirect_to root_path, alert: "It looks like you haven't listed any services yet, please list your services on our directory before you begin"
      return
    end

    session[:organisation_id] = org_id
    session[:services] = services
    session[:uid] = auth_hash.uid
    session[:user_email] = auth_hash.info.email

    redirect_to employees_path
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
