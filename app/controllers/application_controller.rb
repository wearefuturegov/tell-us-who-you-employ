class ApplicationController < ActionController::Base
  before_action :set_paper_trail_whodunnit
  helper_method :user_signed_in?, :admin?

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


  def authenticate_user!
    unless session[:uid]
      redirect_to start_path
    end
  end

  # moved here from sessions_controller since an admin might also need to submit employee data
  # First check that the user is associated with an organisation and has listed
  # services; if they haven't, they can't use this service
  def check_user_eligibility!
    if (session[:organisation_id].nil? || session[:services].empty?)
      redirect_to root_path, alert: "It looks like you haven't listed any services yet, please list your services on our directory before you begin"
      return
    end
  end 

  def require_admin!
    unless admin?
      redirect_to employees_path
    end
  end

  def user_admins_only!
    unless admin_users? 
      redirect_to request.referer, notice: "You don't have permission to edit other users."
    end
  end

end
