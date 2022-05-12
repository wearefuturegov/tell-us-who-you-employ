class AddSencoTrainingEarlyYears < ActiveRecord::Migration[6.1]
  def change
    add_column :employees, :has_senco_early_years, :boolean
    add_column :employees, :senco_early_years_achieved_on, :date
  end
end
