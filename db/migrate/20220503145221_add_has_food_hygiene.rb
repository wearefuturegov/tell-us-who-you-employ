class AddHasFoodHygiene < ActiveRecord::Migration[6.1]
  def change
    add_column :employees, :has_food_hygiene, :boolean
    add_column :employees, :food_hygiene_achieved_on, :date
  end
end
