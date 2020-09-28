class EmployeesController < ApplicationController
    before_action :set_employees, only: :index

    def index
    end

    def show
    end

    def create
    end

    def update
    end


    def delete
    end

    private

    def set_employees
        @employees = Employee.all
    end

    def employee_params
    end
end