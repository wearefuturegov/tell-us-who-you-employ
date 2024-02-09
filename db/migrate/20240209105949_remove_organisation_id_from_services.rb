class RemoveOrganisationIdFromServices < ActiveRecord::Migration[6.1]
  def change
    remove_column :services, :organisation_id, :integer
  end
end
