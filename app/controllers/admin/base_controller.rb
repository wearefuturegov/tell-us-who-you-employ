class Admin::BaseController < ApplicationController
  before_action :require_admin!
  helper_method :admin?, :admin_users?

  private

  # admin maps to readonly_admin in outpost
  def admin?
    session[:admin] === true
  end

  # admin_users maps to can manage users in outpost they will also have readonly_admin status in outpost too
  def admin_users?
    session[:admin_users] === true
  end

  def user_admins_only
    unless admin_users? 
      redirect_to request.referer, notice: "You don't have permission to edit other users."
    end
  end

  def require_admin!
    unless admin?
      redirect_to employees_path
    end
  end



end