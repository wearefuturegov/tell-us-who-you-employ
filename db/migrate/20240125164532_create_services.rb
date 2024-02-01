class CreateServices < ActiveRecord::Migration[6.1]
  def change
    create_table :services do |t|
      t.string :name
      t.string :location_name
      t.string :address_1
      t.string :city
      t.string :postal_code
    end
  end
end
