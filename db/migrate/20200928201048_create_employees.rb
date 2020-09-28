class CreateEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :employees do |t|
      t.string :last_name
      t.string :other_names
      t.string :role
      t.date :employed_from
      t.date :employed_to

      t.timestamps
    end
  end
end
