class FlowController < ApplicationController
    def start
    end

    def eligibility
    end

    def check_eligibility
        if params[:eligible] === "yes"
            redirect_to "/auth/outpost"
        else
            redirect_to eligibility_path, notice: "You can't proceed without an account. Register for one first"
        end
    end

    def finish
        if params[:confirm_validity]
            session[:user] = nil
        else
            redirect_to employees_path, notice: "You must confirm these records are correct before finishing"
        end
    end
end