class SessionsController < ApplicationController
    def create
        session[:uid] = auth_hash.uid
        session[:user_email] = auth_hash.info.email
        session[:organisation_id] = auth_hash.extra.raw_info.organisation.id
        session[:services] = auth_hash.extra.raw_info.organisation.services
        redirect_to employees_path
    end

    private

    def auth_hash
        request.env['omniauth.auth']
    end
end