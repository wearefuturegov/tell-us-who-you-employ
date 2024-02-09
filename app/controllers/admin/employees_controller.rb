class Admin::EmployeesController < Admin::BaseController
  before_action :require_admin!, only: [:index, :show]
  before_action :require_admin_users!, only: [:edit, :update, :destroy]

  include ApplicationHelper
  include Sortable
  def index
    @filterrific_params = params[:filterrific] || {}
    @employees = Employee.includes(:service)
    @filterrific = initialize_filterrific(
      Employee,
      @filterrific_params,
      select_options: {
        job_title: Employee.options_for_job_title,
        status: Employee.options_for_status,
        qualifications: Employee.options_for_qualifications,
        service: Employee.options_for_service(),
      },
      persistence_id: 'false',
    ) or return
    
    @employees = @filterrific.find
    @employees = apply_sort(@employees, params, 'forenames', %w[forenames surname job_title service_name qualifications status])
    @employees = @employees.page(params[:page]).per(20)
  end

  def show
    @employee = Employee.find(params[:id])
  end

  def edit
    @employee = Employee.find(params[:id])
    @services = Service.all.collect { |s| [s.name, s.id] }
  end


  def update
    @employee = Employee.find(params[:id])
    submitted_roles = params[:employee][:roles] || [] 
    submitted_qualifications = params[:employee][:qualifications] || []  
    @employee.roles = submitted_roles
    @employee.qualifications = submitted_qualifications

    ATTRIBUTE_FLAGS.each do |flag, attrs|
      if employee_params[flag] == "true"
        attrs.each { |attr| @employee.send("#{attr}=", nil) }
      end
    end
  
    @employee.assign_attributes(employee_params.except(:remove_dbs, :remove_firstaid, :remove_foodhygiene, :remove_senco, :remove_safeguarding, :remove_earlyyears))

    
    if @employee.save
      redirect_to admin_employee_path(@employee), notice: 'Employee updated successfully.'
    else
      render :edit
    end
  end
  

  def destroy
    @employee = Employee.find(params[:id])
    @employee.destroy
    redirect_to admin_employees_path, notice: 'Employee was successfully destroyed.'
  end

  
  private
  def employee_params
    params.require(:employee).permit(:forenames, :surname, :job_title, :status, :qualifications, :roles, :service_id, :remove_dbs, :remove_firstaid, :remove_foodhygiene, :remove_senco, :remove_safeguarding, :remove_earlyyears)
  end

  ATTRIBUTE_FLAGS = {
    remove_dbs: [:has_dbs_check, :dbs_achieved_on],
    remove_firstaid: [:has_first_aid_training, :first_aid_achieved_on],
    remove_foodhygiene: [:has_food_hygiene, :food_hygiene_achieved_on],
    remove_senco: [:has_senco_training, :senco_achieved_on],
    remove_safeguarding: [:has_safeguarding, :safeguarding_achieved_on],
    remove_earlyyears: [:has_senco_early_years, :senco_early_years_achieved_on]
    }.freeze

end
