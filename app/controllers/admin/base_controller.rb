class Admin::BaseController < ApplicationController
  helper_method :admin?, :admin_users?

  private

  def admin?
    session[:admin] == true
  end

  def admin_users?
    session[:admin_users] == true
  end

  def require_admin!
    unless admin?
      redirect_to employees_path, notice: "You don't have permission to access the admin portal."
    end
  end

  def require_admin_users!
    unless admin_users?
      redirect_to employees_path, notice: "You don't have permission to edit records."
    end
  end
end