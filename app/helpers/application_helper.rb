module ApplicationHelper

  def service_name_by_id(id)
    result = session[:services].find{|s| s["id"] === id }
    if result
      result["name"]
    else
      id
    end
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

  def sortable_table_column(label, column, sort_params, service_id: nil, show_service_specific_table: false)
    is_current_sort = sort_params[:sort] == column.to_s
    sort_direction = is_current_sort && sort_params[:direction] == 'asc' ? 'desc' : 'asc'
    arrow_direction = is_current_sort && sort_params[:direction] == 'desc' ? 'up' : 'down'

    path = if show_service_specific_table
      service_id.present? ? admin_service_path(id: service_id, sort: column, direction: sort_direction) : admin_services_path(sort: column, direction: sort_direction)
    else
      admin_employees_path(sort: column, direction: sort_direction)
    end

    link_to path do
      safe_join([label, image_tag("#{arrow_direction}-arrow.svg", alt: "Sort by #{label}", class: "sorting-icon")], ' ')
    end
  end
end
