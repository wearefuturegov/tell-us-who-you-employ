class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

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
    persist_services_from_session if session[:services].present?

    redirect_to employees_path
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
  
      if service_data['service_at_locations'].present?
        location_data = service_data['service_at_locations'].first&.dig('location')&.to_h
  
        if location_data
          service.location_name = location_data['name']
          service.address_1 = location_data['address_1']
          service.city = location_data['city']
          service.postal_code = location_data['postal_code']
          service.save
        end
      end
    end
  end
end
