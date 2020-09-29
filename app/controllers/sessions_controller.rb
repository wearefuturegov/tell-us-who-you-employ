class SessionsController < ApplicationController
    def create
        session[:user] = 1
        redirect_to employees_path
    end
end