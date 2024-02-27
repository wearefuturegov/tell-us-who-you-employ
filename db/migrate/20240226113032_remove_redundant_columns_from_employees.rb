class RemoveRedundantColumnsFromEmployees < ActiveRecord::Migration[6.1]
  def change
    remove_column :employees, :is_potential_duplicate, :boolean
    remove_column :employees, :ignore_duplicate, :boolean
  end
end
