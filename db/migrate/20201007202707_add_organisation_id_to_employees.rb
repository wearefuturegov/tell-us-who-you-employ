class AddOrganisationIdToEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :organisation_id, :integer
  end
end
