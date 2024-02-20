class Admin::BaseController < ApplicationController
  before_action :require_admin!
  helper_method :admin?, :admin_users?
end