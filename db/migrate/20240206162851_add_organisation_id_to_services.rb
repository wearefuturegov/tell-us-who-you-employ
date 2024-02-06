class AddOrganisationIdToServices < ActiveRecord::Migration[6.1]
  def change
    add_column :services, :organisation_id, :integer
  end
end
