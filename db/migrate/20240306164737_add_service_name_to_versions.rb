class AddServiceNameToVersions < ActiveRecord::Migration[6.1]
  def change
    add_column :versions, :service_name, :string
  end
end
