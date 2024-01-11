class AddRoleToEmployees < ActiveRecord::Migration[6.1]
  def change
    add_column :employees, :roles, :string, array: true
  end
end
