class AddTimestampsToServices < ActiveRecord::Migration[6.1]
  def change
    add_timestamps :services, null: false, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
