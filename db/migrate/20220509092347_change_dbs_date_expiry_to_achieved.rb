class ChangeDbsDateExpiryToAchieved < ActiveRecord::Migration[6.1]
  def change
    rename_column :employees, :dbs_expires_at, :dbs_achieved_on
  end
end
