class CreateDuplicateRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :duplicate_records do |t|
      t.references :employee1, null: false, foreign_key: {to_table: :employees}
      t.references :employee2, null: false, foreign_key: {to_table: :employees}
      t.boolean :reviewed, default: false
      t.string :decision
      t.datetime :review_date

      t.timestamps
    end
  end
end
