class EmployeesController < ApplicationController
    before_action :set_employees, only: :index
    before_action :set_employee, only: [:show, :destroy]

    def index
    end

    def new
        @employee = Employee.new
    end

    def create
        @employee = Employee.new(employee_params)
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
        @employees = Employee.all
    end

    def set_employee
        @employee = Employee.find(params[:id])
    end

    def employee_params
        params.require(:employee).permit(
            :last_name,
            :other_names,
            :role,
            :employed_from,
            :employed_to
        )
    end
end