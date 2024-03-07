class ApplicationController < ActionController::Base
  before_action :set_paper_trail_whodunnit
  helper_method :user_signed_in?, :admin?, :admin_users?

  private

  def user_signed_in?
    !session[:uid].nil?
  end

  # admin maps to readonly_admin in outpost so you can safely use this to check if a user is an admin
  def admin?
    session[:admin] === true
  end

  # admin_users maps to admins who have 'can manage users' role in outpost (they will also have admin: true)
  def admin_users?
    session[:admin_users] === true
  end

  # admin_users maps to admins who have 'can manage users' role in outpost (they will also have admin: true)
  def superadmin?
    session[:superadmin] === true
  end

  def authenticate_user!
    unless session[:uid]
      redirect_to start_path
    end
  end

  def current_user
    if session[:first_name] && session[:last_name]
      @current_user ||= [session[:first_name], session[:last_name]].join(' ')
    else
      nil
    end
  end
  

  def user_for_paper_trail
    session.nil? ? 'Unknown' : session[:uid] 
  end


  # moved here from sessions_controller since an admin might also need to submit employee data
  # First check that the user is associated with an organisation and has listed
  # services; if they haven't, they can't use this service
  def check_user_eligibility!
    if (session[:organisation_id].nil? || session[:services].empty?)
      flash_alert = "It looks like you haven't listed any services yet, please list your services on our directory before you begin"
      reset_session unless admin?
      redirect_to root_path, alert: flash_alert
      return
    end
  end 

  # 99% of the time this is the check you need
  def authenticate_admin!
    unless admin? 
      redirect_to admin_start_path
    end
  end

  # for utility purposes 
  def authenticate_superadmin!
    unless superadmin? 
      redirect_to admin_start_path
    end
  end
  

  # use this for higher level privileges and editing data
  def user_admins_only!
    unless admin_users? 
      redirect_back fallback_location: admin_start_path, notice: "You don't have permission to edit other users."
    end
  end

  def redirect_if_admin_logged_in!
    if admin?
      redirect_to admin_employees_path
    elsif user_signed_in?
      redirect_to employees_path
    end
  end

end
