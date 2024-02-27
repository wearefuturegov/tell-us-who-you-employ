class AddMarkedForDeletionToEmployees < ActiveRecord::Migration[6.1]
  def change
    add_column :employees, :marked_for_deletion, :datetime
  end
end
