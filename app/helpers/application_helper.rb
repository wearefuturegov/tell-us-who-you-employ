include Filterrific

module ApplicationHelper

  def service_name_by_id(id)
    if session[:services]
      result = session[:services].find{|s| s["id"] === id }
      return result["name"] if result
    else 
      result = Service.where(id: id).pluck(:name)
      return result.join(' ')  if result
    end
  
    return id
  end


  def get_current_sorted_by

    if params[:filterrific].nil? || params[:filterrific]['sorted_by'].nil?
      return nil
    end

    sorted_by = params[:filterrific]['sorted_by']
    parts = sorted_by.split('_')
    direction = parts.last
    sorted_column = parts[0...-1].join('_')
    return sorted_column
  end

  def get_current_sorted_direction

    if params[:filterrific].nil? || params[:filterrific]['sorted_by'].nil?
      return nil
    end

    sorted_by = params[:filterrific]['sorted_by']
    parts = sorted_by.split('_')
    direction = parts.last
    sorted_column = parts[0...-1].join('_')
    return direction
  end

  def is_sorted_by?(column)
    sorted_column = get_current_sorted_by
    return column == sorted_column 
  end 

  def sort_column_by(label, column)
  
    directions = { 'asc' => 'Ascending', 'desc' => 'Descending' }     
    current_direction = get_current_sorted_direction if is_sorted_by?(column) 
    new_direction = current_direction == 'asc' ? 'desc' : 'asc' 
    
    new_column = [column, new_direction].join('_')

    render partial: 'admin/shared/sort_button', locals: { 
      directions: directions,
      current_direction: current_direction,
      new_direction: new_direction,
      label: label,
      new_column: new_column 
    }
    
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

  def status_tag(status)
    if status.downcase === "active"
        "<span class='tag'>Active</span".html_safe
    elsif status === "pending" || status === "proposed"
        "<span class='tag tag--yellow'>Pending</span".html_safe
    elsif status === "marked for deletion"
        "<span class='tag tag--red'>Marked for deletion</span".html_safe
    else
        "<span class='tag tag--grey'>#{status.capitalize}</span".html_safe
    end
  end

  def body_class
    'flow-content' unless controller_path.start_with?('admin/')
  end
end
