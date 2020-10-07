class AddServiceIdToEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :service_id, :integer
  end
end
