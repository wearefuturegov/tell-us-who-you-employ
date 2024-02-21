class Admin::EmployeesController < Admin::BaseController
  before_action :set_employee, only: [:update]
  before_action :set_services, only: [:edit, :update]

  def index
    @filterrific = initialize_filterrific(
      Employee,
      params[:filterrific],
      persistence_id: false,
      select_options: {
        job_title: Employee.options_for_job_title,
        status: Employee.options_for_status,
        qualifications: Employee.options_for_qualifications,
        service: Employee.options_for_service,
        sorted_by: Employee.options_for_sorted_by,
      },
    ) or return
    
    @employees = @filterrific.find.page(params[:page]).includes(:service).per(20)
  end

  def show
    @employee = Employee.find(params[:id])
  end

  def edit
    @employee = Employee.find(params[:id])
  end


  def update
    ActiveRecord::Base.transaction do
      update_employment_status
      update_skills
      remove_skills
      update_roles_and_qualifications
      update_employee_attributes
    end

    if @employee.save
      redirect_to admin_employee_path(@employee), notice: 'Employee updated successfully.'
    else
      render :edit
    end
  rescue => e
    Rails.logger.error "Error updating employee: #{e.message}"
    if @employee.present?
      redirect_to edit_admin_employee_path(@employee), alert: 'An error occurred while updating the employee.'
    else
      redirect_to admin_employees_path, alert: 'Employee not found.'
    end
  end
  

  def destroy
    @employee = Employee.find(params[:id])
    @employee.soft_delete
    redirect_to admin_employees_path, notice: 'Employee was successfully deleted.'
  end

  
  private

  def employee_params
    params.require(:employee).permit(
      :forenames, 
      :surname, 
      :date_of_birth, 
      :street_address,
      :postal_code, 
      :service_id, 
      :employed_from, 
      :currently_employed, 
      :employed_to, 
      :job_title,
      :skills,
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
      :remove_dbs, 
      :remove_firstaid, 
      :remove_foodhygiene, 
      :remove_senco, 
      :remove_safeguarding, 
      :remove_earlyyears,
      :roles => [], 
      :qualifications => []
      )
  end

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def update_employment_status
    if employee_params[:currently_employed] == "1"
      @employee.employed_to = nil
    end
  end

  def update_skills
    process_skills(params[:employee][:skills]) if params[:employee][:skills].present?
  end

  def remove_skills
    SKILL_REMOVAL_ATTRIBUTES.each do |flag, attrs|
      next unless employee_params[flag] == "true"
      attrs.each { |attr| @employee.send("#{attr}=", nil) }
    end
  end

  def update_roles_and_qualifications
    @employee.roles = params[:employee][:roles] || []
    @employee.qualifications = params[:employee][:qualifications] || []
  end

  def update_employee_attributes
    @employee.assign_attributes(employee_params.except(:remove_dbs, :remove_firstaid, :remove_foodhygiene, :remove_senco, :remove_earlyyears, :remove_safeguarding, :skills))
  end

  SKILL_REMOVAL_ATTRIBUTES = {
    remove_dbs: [:has_dbs_check, :dbs_achieved_on],
    remove_firstaid: [:has_first_aid_training, :first_aid_achieved_on],
    remove_foodhygiene: [:has_food_hygiene, :food_hygiene_achieved_on],
    remove_senco: [:has_senco_training, :senco_achieved_on],
    remove_safeguarding: [:has_safeguarding, :safeguarding_achieved_on],
    remove_earlyyears: [:has_senco_early_years, :senco_early_years_achieved_on]
    }.freeze

  def process_skills(skills)
    skills.each do |_, cert|
      case cert[:type]
      when 'dbs'
        @employee.has_dbs_check = true
        @employee.dbs_achieved_on = cert[:date]
      when 'first_aid'
        @employee.has_first_aid_training = true
        @employee.first_aid_achieved_on = cert[:date]
      when 'food_hygiene'
        @employee.has_food_hygiene = true
        @employee.food_hygiene_achieved_on = cert[:date]
      when 'senco'
        @employee.has_senco_training = true
        @employee.senco_achieved_on = cert[:date]
      when 'safeguarding'
        @employee.has_safeguarding = true
        @employee.safeguarding_achieved_on = cert[:date]
      when 'senco_early_years'
        @employee.has_senco_early_years = true
        @employee.senco_early_years_achieved_on = cert[:date]
      end
    end
  end

  def set_services
    @services = Service.all.collect { |s| [s.name, s.id] }
  end
end
