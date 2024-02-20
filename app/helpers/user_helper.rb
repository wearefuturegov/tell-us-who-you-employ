module UserHelper 
  def display_name
    if session[:first_name] && session[:last_name]
      [session[:first_name], session[:last_name]].join(' ')
    else
      ''
    end
  end

  def user_outpost_profile
    [ENV['OAUTH_SERVER'], 'users/edit'].join('/')
  end

end