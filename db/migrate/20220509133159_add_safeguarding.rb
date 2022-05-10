class AddSafeguarding < ActiveRecord::Migration[6.1]
  def change
    add_column :employees, :has_safeguarding, :boolean
    add_column :employees, :safeguarding_achieved_on, :date
  end
end
