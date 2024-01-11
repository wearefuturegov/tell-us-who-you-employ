class AddSencoTraining < ActiveRecord::Migration[6.1]
  def change
    add_column :employees, :has_senco_training, :boolean
    add_column :employees, :senco_achieved_on, :date
  end
end
