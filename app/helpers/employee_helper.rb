module EmployeeHelper 

  def employee_display_forenames(employee) 
    if employee.forenames.nil?
      employee.forenames = 'NULL'
    end
    employee.forenames
  end

  def employee_display_surname(employee) 
    if employee.surname.nil?
      employee.surname = 'NULL'
    end
    employee.surname
  end

  def employee_display_name(employee) 
    if employee.forenames.nil?
      employee.forenames = 'NULL'
    end
    if employee.surname.nil?
      employee.surname = 'NULL'
    end
    [employee.forenames, employee.surname].join(' ')
  end

  def edit_employee_link(e, text = '')
    if admin_users?
      "<a href=\"#{edit_admin_employee_url(e)}\" class=\"icon-edit\" title=\"Edit #{employee_display_name(e)} \">#{text}<span class=\"visually-hidden\">Edit this employee</span></a>".html_safe
    end 
  end

  # Childminder, Rainbow Nursery or NULL, Rainbow Nursery
  def employee_display_job_summary(employee) 
    if employee.job_title.nil?
      employee.job_title = 'NULL'
    end

    [employee.job_title, employee.service.name].join(', ')
  end

end