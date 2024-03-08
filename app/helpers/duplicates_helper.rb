module DuplicatesHelper

  def flag_duplicate_link(e, text = '')
    if admin_users?
      "<a href=\"#{mark_as_duplicate_admin_employee_url(e)}\" data-method=\"post\" class=\"#{('icon-flag' + (e.duplicate && e.duplicate.is_duplicate ? '' : ' icon-flag--disabled'))}\">#{text}<span class=\"visually-hidden\">Mark as Duplicate</span></a>".html_safe
    end
  end

end
