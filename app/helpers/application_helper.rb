module ApplicationHelper

  def service_name_by_id(id)
    results = session[:services].select{|s| s["id"] === id }
    if results.any?
      results.first["name"]
    else
      id
    end
  end


  def accepted_qualifications
    [
      "Food hygiene",
      "Paediatric first aid (PFA)",
      "Level 2",
      "Level 3",
      "Level 4",
      "Level 5",
      "Level 6",
      "Level 6 (EYPS/QTS)",
      "One GCSE",
      "Two GCSEs",
      "Three or more GCSEs"
    ]
  end

end
