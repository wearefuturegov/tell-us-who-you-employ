class CreateDuplicatesTable < ActiveRecord::Migration[6.1]
  def change
    create_table :duplicates do |t|
      t.references :employee, null: false, foreign_key: true
      t.boolean :is_duplicate, default: false
      t.timestamps
    end
  end
end
