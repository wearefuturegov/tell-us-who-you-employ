class Admin::LoginController < Admin::BaseController
  skip_before_action :authenticate_admin!, only: [:index]
  before_action :redirect_if_admin_logged_in!, only: [:index]

  def index
  end
end
