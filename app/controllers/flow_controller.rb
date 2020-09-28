class FlowController < ApplicationController
    def start
    end

    def eligibility
    end

    def check_eligibility
        if params[:eligible] === "yes"
            redirect_to employees_path
        end
    end

    def confirmation
    end
end