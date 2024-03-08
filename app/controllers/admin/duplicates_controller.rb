class Admin::DuplicatesController < Admin::BaseController
  before_action :user_admins_only!
  before_action :set_duplicate_employees, only: [:index]
  before_action :set_employee_ids


  def index
  end

  def create
     
    if params[:confirm_choice] == 'confirm_merge'
      # we're keeping this record but updating their fields
      target_employee = Employee.find(params[:primary_employee])

      # we're deleting this record but first we take the data from some of their fields
      source_employee = Employee.find(params[:secondary_employee])

      # the fields we're taking from the source record
      updatable_attributes = %w[forenames surname date_of_birth postal_code]

      update_attributes = source_employee.attributes.slice(*updatable_attributes)
      target_employee.update(update_attributes)

      source_employee.soft_delete


      # mark the source as no longer duplicate
      duplicates = Duplicate.where(employee_id: source_employee.id)
      duplicates.update_all(is_duplicate: false)


      # mark target as no longer duplicate if requested
      if params[:confirm_primary_not_duplicate] 
        duplicates = Duplicate.where(employee_id: target_employee.id)
        duplicates.update_all(is_duplicate: false)
      end 

      redirect_to admin_duplicates_path, notice: 'Employees were successfully merged.'

    elsif params[:confirm_choice] == "confirm_delete"
      employee_to_delete = Employee.find(params[:secondary_employee])
      employee_to_delete.soft_delete

      # mark the records as no longer duplicates
      duplicates = Duplicate.where(employee_id: employee_to_delete.id)
      duplicates.update_all(is_duplicate: false)

      # mark primary as no longer duplicate if requested
      if params[:confirm_primary_not_duplicate] 
        employee_to_keep = Employee.find(params[:primary_employee])
        duplicates = Duplicate.where(employee_id: employee_to_keep.id)
        duplicates.update_all(is_duplicate: false)
      end 

      redirect_to admin_duplicates_path, notice: 'Employee was successfully deleted.'
    else
      redirect_to admin_duplicates_path, notice: "No action selected"
    end
  end


  
  private

  def set_employee_ids

    if @duplicate_employees.count > 0
      default_employee_id = @duplicate_employees.first.id
    else 
      default_employee_id = 0
    end


    @primary_employee_id = params[:primary_employee_id] || default_employee_id
    @secondary_employee_id = params[:secondary_employee_id] || default_employee_id
  
    if !params[:primary_employee_id] && !params[:secondary_employee_id]
      redirect_to admin_duplicates_primary_secondary_path(@primary_employee_id, @secondary_employee_id)
    elsif params[:primary_employee_id] && !params[:secondary_employee_id]
      redirect_to admin_duplicates_primary_secondary_path(@primary_employee_id, @secondary_employee_id)
    end



  end

    
  def set_duplicate_employees
    @duplicate_employees = Employee.joins(:duplicate).where(duplicates: { is_duplicate: true }).order('id DESC')
  end

  

end

