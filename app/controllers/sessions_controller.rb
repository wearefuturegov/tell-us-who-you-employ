class SessionsController < ApplicationController
    def create
        session[:user] = auth_hash.info.email
        redirect_to employees_path
    end

    private

    def auth_hash
        request.env['omniauth.auth']
    end
end