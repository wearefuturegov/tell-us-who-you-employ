class ApplicationController < ActionController::Base
  before_action :set_paper_trail_whodunnit
  helper_method :user_signed_in?

  private

  def user_signed_in?
    !session[:uid].nil?
  end

  def current_user
    @current_user ||= session[:uid]
  end

  def authenticate_user!
    unless session[:uid]
      redirect_to start_path
    end
  end
end
