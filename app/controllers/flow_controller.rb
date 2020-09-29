class FlowController < ApplicationController
    def start
    end

    def eligibility
    end

    def check_eligibility
        if params[:eligible] === "yes"
            redirect_to "/auth/google_oauth2"
        end
    end

    def finish
        if params[:confirm_validity]
            session[:user] = nil
        else
            redirect_to employees_path
        end
    end
end