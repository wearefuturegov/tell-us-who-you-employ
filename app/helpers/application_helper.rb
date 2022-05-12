module ApplicationHelper

  def service_name_by_id(id)
    result = session[:services].find{|s| s["id"] === id }
    if result
      result["name"]
    else
      id
    end
  end


  def accepted_qualifications
    [
      "Level 2",
      "Level 3",
      "Level 4",
      "Level 5",
      "Level 6",
      "EYPS",
      "QTS",
      "EYC"
    ]
  end

end
