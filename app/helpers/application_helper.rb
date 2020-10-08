module ApplicationHelper

    def service_name_by_id(id)
        results = session[:services].select{|s| s["id"] === id }
        if results.any?
            results.first["name"]
        else
            id
        end
    end
    
end
