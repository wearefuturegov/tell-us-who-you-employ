module ApplicationHelper

  def service_name_by_id(id)
    result = session[:services].find{|s| s["id"] === id }
    if result
      result["name"]
    else
      id
    end
  end
  
  def service_id_by_name(name)
    return nil if name.blank?
    result = session[:services].find { |s| s["name"].casecmp(name).zero? }
    result ? result["id"] : nil
  end

  def accepted_job_titles 
    [
      "Acting Deputy Manager/Leader/Supervisor",
      "Acting Manager/Leader/Supervisor",
      "Apprentice/Intern",
      "Assistant Childminder",
      "Chair Person",
      "Childminder",
      "Cleaner/Caretaker/Catering",
      "Deputy Manager/Leader/Supervisor",
      "Finance/Administrator/Secretary",
      "Lead Practitioner",
      "Manager/Leader/Supervisor",
      "Nanny",
      "Not Applicable",
      "Nursery/Pre-School Assistant",
      "On Maternity Leave",
      "Owner/Proprietor/Director",
      "Playworker",
      "Room Leader/Supervisor",
      "Treasurer",
      "Volunteer"
    ]
  end

  def accepted_roles
    [
      "Designated Behaviour Management Lead",
      "Designated Safeguarding Lead",
      "Designated SENCO",
      "First Aider",
      "Ofsted Registered Contact",
      "Practice Leader"    
    ]
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
