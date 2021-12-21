class FlowController < ApplicationController
  def start
  end

  def eligibility
  end

  def check_eligibility
    if params[:eligible] === "yes"
      redirect_to eligible_path
    else
      redirect_to ineligible_path
    end
  end

  def eligible
  end

  def ineligible
  end

  def finish
    if params[:confirm_validity]
      # Sign the user out by clearing everything in session
      reset_session
    else
      redirect_to employees_path, notice: "You must confirm these records are correct before finishing"
    end
  end
end
