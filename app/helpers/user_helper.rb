module UserHelper 

  # Returns the user's display name first_name last_name
  def user_session_display_name()
    if session[:first_name] && session[:last_name]
      [session[:first_name], session[:last_name]].join(' ')
    else
      ''
    end
  end

  # Gets the url for the edit profile page in outpost
  def user_outpost_profile
    [ENV['OAUTH_SERVER'], 'users/edit'].join('/')
  end


  def user_admin_outpost_profile(user_id)
    [ENV['OAUTH_SERVER'], 'admin/users', user_id].join('/') unless user_id.nil?
  end

end