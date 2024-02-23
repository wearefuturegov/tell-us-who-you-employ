class RemoveLocationFromServices < ActiveRecord::Migration[6.1]
  def change
    remove_column :services, :location_name, :string
    remove_column :services, :address_1, :string
    remove_column :services, :city, :string
    remove_column :services, :postal_code, :string
  end
end
