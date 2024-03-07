class AddUserNameToVersions < ActiveRecord::Migration[6.1]
  def change
    add_column :versions, :user_name, :string
  end
end
