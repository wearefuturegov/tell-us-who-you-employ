class EmployeesController < ApplicationController
  before_action :authenticate_user!
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
    if @employee.update(employee_params)
      redirect_to employees_path
    else
      render "show"
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
      :last_name,
      :other_names,
      :street_address,
      :postal_code,
      :date_of_birth,

      :service_id,
      :job_title,
      :employed_from,
      :employed_to,
      :currently_employed,

      :has_dbs_check,
      :dbs_expires_at,
      :has_first_aid_training,
      :first_aid_expires_at,
      :qualifications => [],
      :roles => []
    )
  end
end
