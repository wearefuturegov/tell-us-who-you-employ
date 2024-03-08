class CreateServiceSyncs < ActiveRecord::Migration[6.1]
  def change
    create_table :service_syncs do |t|
      t.integer :uid
      t.integer :number_changed

      t.timestamps
    end
  end
end
