module ServiceHelper 

  # on the frontend we can safely get the session name from the session
  def get_service_name_from_session(service_id) 
    service = session[:services].find { |service| service["id"] == service_id }
    if service
      service_name = service["name"]
    else
      service_name = "Unknown service name"
    end
  end

  # on the backend we get the service name from the database/cache
  def get_service_name_from_object(services, service_id)
    service = services.find { |service| service["id"].to_s == service_id }
    if service
      service_name = service["name"]
    else
      service_name = "Unknown service name"
    end
  end

  

end