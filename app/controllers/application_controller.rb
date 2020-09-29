class ApplicationController < ActionController::Base

    private

    def current_user
        @current_user ||= session[:user]
    end

    def authenticate_user!
        unless session[:user]
            redirect_to start_path
        end
    end
end
