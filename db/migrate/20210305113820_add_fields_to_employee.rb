class AddFieldsToEmployee < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :street_address, :string
    add_column :employees, :postal_code, :string
    add_column :employees, :date_of_birth, :date
    add_column :employees, :has_dbs_check, :boolean
    add_column :employees, :dbs_expires_at, :date
    add_column :employees, :has_first_aid_training, :boolean
    add_column :employees, :first_aid_expires_at, :date
    add_column :employees, :qualifications, :string, array: true
  end
end
