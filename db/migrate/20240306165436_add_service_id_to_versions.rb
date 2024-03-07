class AddServiceIdToVersions < ActiveRecord::Migration[6.1]
  def change
    add_column :versions, :service_id, :integer
  end
end
