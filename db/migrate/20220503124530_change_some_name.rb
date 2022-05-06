class ChangeSomeName < ActiveRecord::Migration[6.1]
  def change
    rename_column :employees, :last_name, :surname
    rename_column :employees, :other_names, :forenames
  end
end
