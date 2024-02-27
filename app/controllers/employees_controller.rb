class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_eligibility!
  before_action :set_employees, only: :index
  before_action :set_employee, only: [:show, :update, :destroy]

  def index
  end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)
    @employee.organisation_id = session[:organisation_id]
    if @employee.save
      redirect_to employees_path
    else
      render "new"
    end
  end

  def show
  end

  def update  
    if params[:confirm_details] == 'true'
      @employee.touch(:updated_at)
      redirect_to employees_path, notice: 'Employee details confirmed.'
    else
      if @employee.update(employee_params)
        redirect_to employees_path, notice: 'Employee updated successfully.'
      else
        render "show"
      end
    end
  end

  def destroy
    if @employee.destroy
      redirect_to employees_path
    end
  end

  private

  def set_employees
    @employees = Employee.where(organisation_id: session[:organisation_id])
  end

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(
      :surname,
      :forenames,
      :street_address,
      :postal_code,
      :date_of_birth,

      :service_id,
      :job_title,
      :employed_from,
      :employed_to,
      :currently_employed,

      :has_dbs_check,
      :dbs_achieved_on,
      :has_first_aid_training,
      :first_aid_achieved_on,
      :has_food_hygiene,
      :food_hygiene_achieved_on,
      :has_senco_training,
      :senco_achieved_on,
      :has_safeguarding,
      :safeguarding_achieved_on,
      :has_senco_early_years,
      :senco_early_years_achieved_on,
      :qualifications => [],
      :roles => []
    )
  end
end
