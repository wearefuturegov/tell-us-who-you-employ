class Admin::BaseController < ApplicationController
  before_action :authenticate_admin!
  helper_method :admin?, :admin_users?

  private

end