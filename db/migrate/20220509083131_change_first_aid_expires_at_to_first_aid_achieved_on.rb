class ChangeFirstAidExpiresAtToFirstAidAchievedOn < ActiveRecord::Migration[6.1]
  def change
    rename_column :employees, :first_aid_expires_at, :first_aid_achieved_on
  end
end
