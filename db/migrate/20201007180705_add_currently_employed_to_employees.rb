class AddCurrentlyEmployedToEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :currently_employed, :boolean
  end
end
