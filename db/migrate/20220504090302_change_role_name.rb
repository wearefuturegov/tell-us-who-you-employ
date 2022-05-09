class ChangeRoleName < ActiveRecord::Migration[6.1]
  def change
    rename_column :employees, :role, :job_title
  end
end
